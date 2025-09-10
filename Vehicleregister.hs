import System.IO (hFlush, stdout)
import Data.Char (toLower)

type Model = String
type Year  = Int
type RegNo = String

data Status = Registered | Unregistered deriving (Show, Eq)

data Vehicle = Vehicle
  { vModel  :: Model
  , vYear   :: Year
  , vRegNo  :: RegNo
  , vStatus :: Status
  } deriving (Show, Eq)

-- Pretty print
showVehicle :: Vehicle -> String
showVehicle (Vehicle m y r s) =
  "Vehicle { model = " ++ m ++ ", year = " ++ show y
  ++ ", regNo = " ++ r ++ ", status = " ++ show s ++ " }"

-- Case-insensitive trim/compare helpers
trim :: String -> String
trim = f . f where f = reverse . dropWhile (== ' ')

lower :: String -> String
lower = map toLower

-- Parse Status from user input
parseStatus :: String -> Maybe Status
parseStatus s =
  case lower (trim s) of
    "registered"   -> Just Registered
    "unregistered" -> Just Unregistered
    _              -> Nothing

-- Search by RegNo (exact match)
findVehicle :: RegNo -> [Vehicle] -> Maybe Vehicle
findVehicle regNo = go
  where
    go (v:vs) | vRegNo v == regNo = Just v
              | otherwise         = go vs
    go [] = Nothing

-- Prompt helpers
prompt :: String -> IO String
prompt msg = do
  putStr msg
  hFlush stdout
  getLine

readYear :: IO Year
readYear = do
  s <- prompt "Enter year (e.g., 2019): "
  case reads s :: [(Int, String)] of
    [(n,"")] -> pure n
    _        -> putStrLn "Invalid year. Try again." >> readYear

readStatus :: IO Status
readStatus = do
  s <- prompt "Enter status (Registered/Unregistered): "
  case parseStatus s of
    Just st -> pure st
    Nothing -> putStrLn "Invalid status. Try again." >> readStatus

-- Add a vehicle (with duplicate RegNo check)
addVehicle :: [Vehicle] -> IO [Vehicle]
addVehicle reg = do
  putStrLn "\n--- Add Vehicle ---"
  model <- prompt "Enter model: "
  year  <- readYear
  regNo <- prompt "Enter registration number (unique): "
  case findVehicle regNo reg of
    Just _  -> putStrLn "A vehicle with that RegNo already exists. Cancelled." >> pure reg
    Nothing -> do
      status <- readStatus
      let v = Vehicle { vModel = model, vYear = year, vRegNo = regNo, vStatus = status }
      putStrLn "Vehicle added:"
      putStrLn ("  " ++ showVehicle v)
      pure (v : reg)

-- List all vehicles
listVehicles :: [Vehicle] -> IO ()
listVehicles [] = putStrLn "(No vehicles in register.)"
listVehicles vs = mapM_ (putStrLn . ("  " ++) . showVehicle) (reverse vs) -- newest last

-- Search flow
searchFlow :: [Vehicle] -> IO ()
searchFlow reg = do
  putStrLn "\n--- Search Vehicle ---"
  q <- prompt "Enter registration number: "
  case findVehicle q reg of
    Just v  -> putStrLn ("Found:\n  " ++ showVehicle v)
    Nothing -> putStrLn "No vehicle found."

-- Menu loop
menu :: [Vehicle] -> IO ()
menu reg = do
  putStrLn "\n====== Vehicle Register ======"
  putStrLn "1) List vehicles"
  putStrLn "2) Search by RegNo"
  putStrLn "3) Add vehicle"
  putStrLn "4) Quit"
  choice <- prompt "Choose an option (1-4): "
  case choice of
    "1" -> listVehicles reg >> menu reg
    "2" -> searchFlow reg   >> menu reg
    "3" -> addVehicle reg   >>= menu
    "4" -> putStrLn "Goodbye!"
    _   -> putStrLn "Invalid choice." >> menu reg

-- Seed data
seed :: [Vehicle]
seed =
  [ Vehicle "Toyota Corolla"   2015 "ABC123GP" Registered
  , Vehicle "Ford Ranger"      2020 "XYZ789MP" Unregistered
  , Vehicle "Volkswagen Polo"  2018 "VWP456FS" Registered
  , Vehicle "BMW X5"           2021 "BMW999GP" Registered
  , Vehicle "Mercedes C200"    2017 "MER777WC" Unregistered
  ]

main :: IO ()
main = do
  putStrLn "Loaded seed register with 5 vehicles."
  menu seed
