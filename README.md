# UH-60L DCS Mod
A free UH-60L Black Hawk mod for Digital Combat Simulator
## Download
Download the latest version from the [releases page](https://github.com/Kinkkujuustovoileipa/uh-60l/releases)
## Guide
- [Link](https://docs.google.com/presentation/d/1kCJf5Nk-fU_21eO7W1ozYfb9FKt488ax65IbeuIGVtA/edit?usp=sharing)
Manual is also available in-game
## Installation
- Extract the ‘Mods’ folder from the zip file into C:\Users\###\Saved Games\DCS\ folder (Steam) or C:\Users\###\Saved Games\DCS.OpenBeta\ (Standalone if Open Beta installed)
- You may require the latest [C++ redistributables](https://docs.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170) for this mod to work properly
- If you use SRS, copy and paste the “DCS-SimpleRadioStandalone.lua” file to “C:\Users\###\Saved Games\DCS\Mods\Services\DCS-SRS\Scripts\” - BACK UP THE ORIGINAL!
- In the mission editor, make sure the Historical Filter is disabled
## Changelog
### 1.0
- Initial release
### 1.1
#### Feature Changes
- Radios refactored - FM1, UHF, VHF, FM2 radios all work in game
- Communications must be reboud to 'PTT - Push To Talk (Game Comms)' key - Communication key will not work
- Easy Comms mode no longer necessary
- VRS improved
- Flight model improved
- FPS improved
- Pedal trim enabled by default - option to disable to come later
#### Bugs/Corrections
- GPS - We have to manually Enter N for North bug fixed
- Nav flags during ILS bug fixed
- Engine TGT too low correction fixed
- Radar Altitude on HMD brightness doesn't adjust fixed
- Startup without APU bug fixed
- Cockpit flood light correction fixed
- Main Gen's should drop offline at 85% Nr in-flight and 95% Nr on the ground correction fixed
- SearchLight not synced in MP bug fixed
- Starter drop out correction fixed
- VSI Roll Command based on Heading not on Track bug fixed
- HUD brightness switchs bug fixed
- HUD Radar Altitude (AGL) Readout Formats correction fixed
- Radios only work with Easy Comms enabled bug fixed
- Aircraft too fast, too rapid acceleration bug fixed
- HUD Bearing to Waypoint Pointer "V" behavior correction fixed
- Aircraft trim in cruise bug fixed
- Engine torque linked to helicopter pitch, not blade pitch correction fixed
- Tail rotor angle wrong bug fixed
- External sound bug bug fixed
- VRS - too rapid onset; too gentle descent enhancement fixed
- Roll command bar is jittery bug fixed
- FPS on during hot start enhancement fixed
- Clock time runs beyond 2400 bug fixed
- Battery low caution bug fixed
- Tail wheel switch label and operation. correction fixed
- Turning CIS Heading mode ON disables SAS1 bug fixed
- HUD Horizon Line Does Not Roll 0 - 359° correction fixed
- Start without APU bug fixed
- Stabilator Auto Control Mode should be on during startup. correction fixed
- PDU press to test correction fixed
- Radar altimeter low and high correction fixed
- Stabilator Manual Slew Switch correction fixed
- ILS Course Deviation Pointer Is Opposite Steering correction fixed
- Tailwheel Switch Pushbutton lights correction fixed
- HUD Barometric Altitude shows more than 20,000 ft correction fixed
- HUD Changes to "36" when approaching "N" bug fixed
- Torque should not change with forward or aft cyclic movements bug fixed
- Search light correction fixed
- artificial Horizon bug fixed
- ETA to waypoint not working bug fixed
- Fuel Quantity Digital Readout on CDI should display in 10 lb increments correction fixed
- Radar Altimeter Indications correction fixed
- upper and lower beacon light switch - function inverted bug fixed
- Add Checklist to kneeboard documentation enhancement fixed
- Radar Alt HI light not coming over when over Set High Alt bug fixed
- Cabin light switch inverted bug fixed
- HUD Radar Altitude (AGL) Analog Bar Appearance correction fixed
- Have the course and heading knobs adjust by 1 with mouse wheel bug fixed
- HUD Distance to Waypoint shows more than 999.9 km correction fixed
- HUD Indicated Airspeed goes above 180kts correction fixed