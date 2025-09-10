Typing Speed web 
https://typingspeedweb1.oneapp.dev/

A fun and interactive way to boost your typing speed and accuracy!
This app challenges you with random sentences while tracking your performance over time. Whether you’re a beginner or an experienced typist, you can set your own challenge by choosing short or long sentences.

Features

-Typing Practice – Practice with randomly generated sentences to sharpen your typing skills
-Built-in Timer – A real-time timer measures how quickly you complete each challenge.
-Progress Tracking – Stores and displays your typing results so you can monitor improvement.
-Customizable Difficulty – Choose between short or long sentences for tailored practice.
-Accuracy Feedback (Optional Future Feature) – Get a breakdown of your accuracy alongside your speed.

Benefits
-Improves Typing Speed – Train consistently to type faster over time.
-Boosts Accuracy – Practice helps reduce typos and typing errors.
-Enhances Productivity – Faster, more accurate typing makes you more efficient at work, school, or personal projects.
-Tracks Progress – Visual feedback and stored results motivate you to improve.
-Flexible Practice – Choose short sessions for quick practice or long sessions for endurance building.
-No Install Needed – Works directly in your browser, accessible from any device.

How It Works
1. Choose Sentence Length – Select either a short or a long random sentence.
2. Start Typing – Once the sentence appears, begin typing immediately.
3. Timer Starts Automatically – The timer activates as soon as you type your first character.
4. Results Displayed – When you finish, the app shows your total time taken.
5. Records Saved – Your performance is stored so you can track progress over time.

Tech Stack
-HTML5 – Page structure and text display.
-CSS3 – Styling, colors, and animations.
-JavaScript (ES6) – Core app logic, timer, sentence generation, and tracking.




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#2 Vehicle Register (Haskell CLI)

A small interactive command-line program to manage a simple Vehicle Register in memory.
You can list, search, add, update, and delete vehicles by registration number.

✅ No external dependencies — uses only base (works with GHC 9.x) or https://www.onlinegdb.com/#


#Features

-List all vehicles (pretty-printed)
-Search by exact registration number (RegNo)
-Add a vehicle with validation and unique RegNo check
-Update a vehicle (press Enter to keep existing values per field)
-Delete a vehicle (with confirmation)
-Seed data: 5 vehicles preloaded at startup

Data Model
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


#Validation rules
-Year must parse as an Int.
-Status must be exactly Registered or Unregistered (case-insensitive input is supported).
-RegNo must be unique across the register (exact match).
-File Layout
-Single file program (suggested filename): Main.hs

#Key functions:

-menu – main loop with options
-listVehicles, searchFlow
-addVehicle, updateVehicle, deleteVehicle
-findVehicle – exact RegNo lookup
-Helpers: prompt, trim, lower, readYear(_Maybe), readStatus(_Maybe), parseStatus

Build & Run
Option A — ghc (compile)
ghc -O2 -o vehicle-register Main.hs
./vehicle-register            # macOS/Linux
vehicle-register.exe          # Windows

Option B — runghc / runhaskell (interpret)
runghc Main.hs
# or
runhaskell Main.hs

Option C — Cabal (optional)
cabal init --non-interactive --exe --package-name=vehicle-register
# Replace the generated app/Main.hs with this program, then:
cabal build
cabal run vehicle-register

Option D - online complier 
https://www.onlinegdb.com/#

#Usage
On start, the program loads 5 seed vehicles and shows a menu:

====== Vehicle Register ======
1) List vehicles
2) Search by RegNo
3) Add vehicle
4) Update vehicle
5) Delete vehicle
6) Quit
Choose an option (1-6):

@Examples

1. Search → enter e.g. BMW999GP
2.  Add → you’ll be prompted for Model, Year, unique RegNo, and 3. Status
4. Update → enter existing RegNo, then press Enter to keep a field unchanged
5. Delete → enter existing RegNo and confirm with y
6. Extending the Program

#Common additions:
- Add fields like Owner, VIN, Colour, Odometer, LicenseExpiry, etc.
- Persist to disk (CSV/JSON) using libraries:
 CSV: cassava
JSON: aeson
-Make RegNo case-insensitive in search/update/delete:
-import Data.Char (toLower)
-eqCaseInsensitive a b = map toLower a == map toLower b
-Add bulk import/export, filtering, or sorting.

#Known Limitations
- In-memory only (data is lost when the program exits)
- Exact (case-sensitive) matching for RegNo by default
- No concurrency or file locking (single-user CLI)
