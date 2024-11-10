module Main exposing (main)

import Browser
import Html
import Html.Attributes
import Html.Events
import Markdown
import Array

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

type alias Model =
  { slides: List String
  , count: Int
  , index: Int
  }

type Msg
  = NextSlide Int Int
  | PrevSlide Int

init: Model
init =
  let
    slides = List.map String.trim
      (String.split "---" """
# First Slide
Some Text in the first Slide  
---
# Second Slide
Can use images and links  
[link](https://www.example.com)  
![cat_image](https://cataas.com/cat)  
---
# Third Slide
Can use <mark>HTML</mark> Tags directly  
      """)
  in
    Model slides (List.length slides) 1

update: Msg -> Model -> Model
update msg model =
  case msg of
    NextSlide currIndex count ->
      { model | index = min count (currIndex + 1) }
    PrevSlide currIndex ->
      { model | index = max 1 (currIndex - 1) }

view: Model -> Html.Html Msg
view model =
  Html.div []
  [ viewControls model
  , viewSlide model
  ]

viewSlide: Model -> Html.Html Msg
viewSlide model =
  Markdown.toHtmlWith markdownOptions [] (
    Array.get (model.index - 1) (Array.fromList model.slides)
    |> Maybe.withDefault "Oops, no slide for you"
    )

viewControls: Model -> Html.Html Msg
viewControls model =
  Html.div [ Html.Attributes.style "background-color" "#ed1818" ]
  [ Html.button [ Html.Events.onClick (PrevSlide model.index ) ] [ Html.text "Prev" ]
  , Html.text ("Slide " ++ (String.fromInt model.index) ++ "/" ++ (String.fromInt model.count))
  , Html.button [ Html.Events.onClick (NextSlide model.index model.count) ] [ Html.text "Next" ]
  ]

markdownOptions: Markdown.Options
markdownOptions =
  { githubFlavored = Nothing
  , defaultHighlighting = Nothing
  , sanitize = False
  , smartypants = True
  }
