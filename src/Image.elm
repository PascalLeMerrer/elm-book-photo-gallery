module Image exposing (..)


type alias Image =
    { large : String
    , small : String
    }


defaultList : List Image
defaultList =
    [ { small = "http://localhost:7000/images/LON1_small.jpeg", large = "http://localhost:7000/images/LON1_large.jpeg" }
    , { small = "http://localhost:7000/images/LON2_small.jpeg", large = "http://localhost:7000/images/LON2_large.jpeg" }
    , { small = "http://localhost:7000/images/LON3_small.jpeg", large = "http://localhost:7000/images/LON3_large.jpeg" }
    ]
