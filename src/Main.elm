module Main exposing (main)

import Browser
import Html

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

type alias Model =
  { name: String
  }

type Msg
  = Noop

init: Model
init =
  Model "ma5rout"

update: Msg -> Model -> Model
update msg model =
  case msg of
    Noop ->
      model

view: Model -> Html.Html Msg
view model =
  Html.h1 [] [ Html.text model.name ]
