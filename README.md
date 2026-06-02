# venda 

A lightweight, dependency-free Bash script that fetches your Google calendar agenda, translates UTC time to your local timezone dynamically, and displays your day's schedule in chronological order right inside your terminal.

Perfect for adding to your `~/.bashrc` or `~/.zshrc` so you can see your agenda every time you open a terminal window.

## Features
* **Timezone Aware:** Automatically detects and converts Google UTC storage format to your exact local system timezone.
* **Chronologically Sorted:** Automatically lists morning meetings before afternoon tasks using native Linux sorting.
* **Blazing Fast & Lightweight:** Uses native `curl`, `awk`, and `bash` string manipulation no heavy OAuth dependencies, API keys, or bulky Python libraries required.
* **Zero Maintenance:** Runs entirely on standard Linux/POSIX utilities found on any distribution out of the box.

## How it Works Under the Hood

The script works in a 4-step pipeline:

1. **`curl`** silently pulls your private `.ics` iCalendar feed.
2. **`awk`** filters the lines, matching the event start dates (`DTSTART`) against today's date (`YYYYMMDD`), and pairs up the corresponding start times, end times, and titles separated by vertical pipes (`|`).
3. **`while IFS='|' read`** catches these packages and extracts the specific time characters using Bash string slicing (`${variable:start:length}`).
4. **`date -d`** takes the extracted UTC time strings, automatically applies your local computer's timezone offset math, formats it to `HH:MM`, and hands it to **`sort`** to arrange your day chronologically.


## Installation

### 1. Get your Secret Google URL
1. log into [Google Calander](https://calendar.google.com/calendar).
2. Click the **Settings** in the top right corner.
3. Click on your specific calander.
4. Copy your private ICS link.


### 2. Edit the script

```
SecretUrl="Put your url here"

```

### 3. Make it global
To run `venda` from any folder in your filesystem without typing ./venda.sh, move it to your system's local binary directory:

```

sudo cp venda.sh /usr/local/bin/venda
sudo chmod +x /usr/local/bin/venda

```

### 4. Enable Terminal Startup Display

If you want your daily agenda to automatically print out every single time you open up a new terminal window:

For Bash users:

```
echo "venda" >> ~/.bashrc

```
For Zsh users:

```
echo "venda" >> ~/.zshrc

```


