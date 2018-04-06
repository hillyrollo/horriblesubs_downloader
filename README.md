# Horriblesubs Downloader
A script for automatically downloading and organizing anime from HorribleSubs. Made mainly for use with Plex.

## Requirements
- Ruby
- NodeJS
  - tget `npm install -g t-get`

## Usage
### Initial setup
- Clone this repo
- Fill in variables in `horriblesubs.rb`
```
LOG_LOCATION = '/path/to/log.log'
LIBRARY_ROOT = '/path/to/my/lib'
RESOLUTION = 720  # (sd|720|1080)
TRACKING_FILE = '/path/to/tracking.json'
```

### Tracking JSON File
The script expects a JSON file to describe which shows to download.
```
{
  "lib_name": "new_anime",
  "shows": [
    "Just Because!",
    "Juuni Taisen"
  ]
}
```

With the above setup:
- Series to download will be read from the file `/path/to/tracking.json`
- Videos will be downloaded in 720p
- Videos will be saved to `/path/to/my/lib/new_anime/<show>/`
- Logs will be saved to `/path/to/log.log`

### Run the script
`ruby horriblesubs.rb`

That's it. Whenever the script is run it will download any new episodes of shows you're tracking. Recommended to be run in cron so everything will be kept up to date automatically.

## Troubleshooting
If a show you have in your tracking JSON isn't being downloaded, check to make sure the title in the JSON file matches exactly how the title is displayed on the HorribleSubs site.
