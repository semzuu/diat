module Main exposing (main)

import Http
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

main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Model =
  { index: Int
  , slides: List String
  }

type HttpStatusMsg
  = Loading
  | Success String
  | Failure

url: String
url = "http://localhost:6969/slides"

handleHttp: HttpStatusMsg -> Model
handleHttp msg =
  case msg of
    Loading ->
      Model 1 ["Loading Slides... (˶ᵔ ᵕ ᵔ˶)"]
    Success slides ->
      Model 1 (String.trim slides |> String.split "---")
    Failure ->
      Model 1 ["Couldn't Load Slides (ᵕ—ᴗ—)"]

type Msg
  = KeyPress String
  | GotResponse (Result Http.Error String)

subscriptions: Model -> Sub Msg
subscriptions model =
  Browser.Events.onKeyDown
    <| Json.Decode.map KeyPress
    <| Json.Decode.field "code" Json.Decode.string

init: () -> (Model, Cmd Msg)
init _ =
  ( handleHttp Loading
  , Http.get
    { url = url
    , expect = Http.expectString GotResponse
    }
  )

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GotResponse result ->
      case result of
        Ok content ->
          ( handleHttp <| Success content
          , Cmd.none
          )
        Err _ ->
          ( handleHttp <| Failure
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
      |> Maybe.withDefault ""
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
  ]

markdownOptions: Markdown.Options
markdownOptions =
  { githubFlavored = Nothing
  , defaultHighlighting = Nothing
  , sanitize = False
  , smartypants = True
  }
