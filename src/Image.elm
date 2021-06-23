module Image exposing (..)


type alias Image =
    { large : String
    , small : String
    , title : String
    }


defaultList : List Image
defaultList =
    [ { small = "http://localhost:7000/images/LON1_small.jpeg"
      , large = "http://localhost:7000/images/LON1_large.jpeg"
      , title = "Londres 1"
      }
    , { small = "http://localhost:7000/images/LON2_small.jpeg"
      , large = "http://localhost:7000/images/LON2_large.jpeg"
      , title = "Londres 2"
      }
    , { small = "http://localhost:7000/images/LON3_small.jpeg"
      , large = "http://localhost:7000/images/LON3_large.jpeg"
      , title = "Londres 3"
      }
    ]
