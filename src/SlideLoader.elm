port module SlideLoader exposing (..)

type alias Slides =
  { name: String
  , content: String
  }

port slideSelected: String -> Cmd msg

port slideContentRead: (Slides -> msg) -> Sub msg
