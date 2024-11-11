module Main exposing (main)

import Task
import File
import Browser
import Browser.Events
import Html
import Html.Attributes
import Html.Events
import Markdown
import Array
import Json.Decode
import SlideLoader

main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Model =
  { loaderId: String
  , index: Int
  , slides: List String
  }

type Msg
  = KeyPress String
  | SlideSelected
  | SlideLoaded SlideLoader.Slides

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Browser.Events.onKeyDown
    <| Json.Decode.map KeyPress
    <| Json.Decode.field "code" Json.Decode.string
  , SlideLoader.slideContentRead SlideLoaded
  ]

init: () -> (Model, Cmd Msg)
init _ =
  ( Model "slide-loader" 1 []
  , Cmd.none
  )

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SlideSelected ->
      ( model
      , SlideLoader.slideSelected model.loaderId
      )
    SlideLoaded data ->
      let
        newSlides =
          { content = data.content
          , name = data.name
          }
      in
        ( { model
          | slides =
            String.trim newSlides.content
            |> String.split "---"
          }
        , Cmd.none
        )
    KeyPress keyCode ->
      case keyCode of
        "ArrowRight" ->
          ( { model | index = min (List.length model.slides) (model.index + 1) }
          , Cmd.none
          )
        "ArrowLeft" ->
          ( { model | index = max 1 (model.index - 1) }
          , Cmd.none
          )
        _ ->
          ( model
          , Cmd.none
          )


view: Model -> Html.Html Msg
view model =
  Html.div []
  [ viewControls model
  , viewSlide model
  ]

viewSlide: Model -> Html.Html Msg
viewSlide model =
  Html.div [ Html.Attributes.class "slide-view" ]
  [ Markdown.toHtmlWith markdownOptions [ Html.Attributes.class "slide" ] (
      Array.get (model.index - 1) (Array.fromList model.slides)
      |> Maybe.withDefault "Oops, no slide for you"
      )
  ]

viewControls: Model -> Html.Html Msg
viewControls model =
  Html.div
  [ Html.Attributes.class "slide-controls"
  ]
  [ Html.button [ Html.Events.onClick (KeyPress "ArrowLeft") ] [ Html.text "Prev" ]
  , Html.text ("Slide " ++ (String.fromInt model.index) ++ "/" ++ (String.fromInt (List.length model.slides)))
  , Html.button [ Html.Events.onClick (KeyPress "ArrowRight") ] [ Html.text "Next" ]
  , Html.input
    [ Html.Attributes.type_ "file"
    , Html.Attributes.id model.loaderId
    , Html.Events.on "change" (Json.Decode.succeed SlideSelected)
    ] []
  ]

markdownOptions: Markdown.Options
markdownOptions =
  { githubFlavored = Nothing
  , defaultHighlighting = Nothing
  , sanitize = False
  , smartypants = True
  }
