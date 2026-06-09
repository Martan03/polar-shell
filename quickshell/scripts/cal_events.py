#!/usr/bin/env python3
import json
import subprocess
import sys
from datetime import datetime, timedelta

PRIMARY_CALENDAR = "martinslezak03@gmail.com"


def fetch_events(start_date, end_date):
    cmd = ["gcalcli", "agenda", start_date, end_date, "--tsv", "--details", "all"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)

        events = parse_output(result.stdout)
        print(json.dumps(events))

    except Exception as e:
        print(json.dumps({"error": str(e)}), file=sys.stderr)


def parse_output(output):
    events = {}

    for line in output.strip().split("\n"):
        if not line:
            continue
        parts = line.split("\t")

        if parts[0] == "id" or len(parts) < 14:
            continue

        start_date_val = parts[1]
        start_time = parts[2]
        end_time = parts[4]
        title = parts[9]
        calendar = parts[12]

        is_main = calendar == PRIMARY_CALENDAR

        if not start_time or start_time == "00:00:00":
            display_time = "All Day"
        else:
            sh = ":".join(start_time.split(":")[:2])
            eh = ":".join(end_time.split(":")[:2]) if end_time else ""
            display_time = f"{sh} - {eh}" if eh else sh

        if start_date_val not in events:
            events[start_date_val] = []

        events[start_date_val].append(
            {"time": display_time, "title": title, "isMain": is_main}
        )
    return events


if __name__ == "__main__":
    if len(sys.argv) >= 3:
        start_date = sys.argv[1]
        end_date = sys.argv[2]
    else:
        now = datetime.now()
        start_date = (now - timedelta(15)).strftime("%Y-%m-%d")
        end_date = (now + timedelta(45)).strftime("%Y-%m-%d")

    fetch_events(start_date, end_date)
