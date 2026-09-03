import csv
import random

def create_sample(input_file, output_file, sample_size):
    with open(input_file, "r", encoding="utf-8") as file:
        reader = csv.reader(file)

        header = next(reader)
        rows = list(reader)

    sample_rows = random.sample(rows, min(sample_size, len(rows)))

    with open(output_file, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)

        writer.writerow(header)
        writer.writerows(sample_rows)

    print(f"Created {output_file} with {len(sample_rows)} rows")


create_sample(
    "athlete_events_cleaned.csv",
    "athlete_events_sample.csv",
    10000
)

create_sample(
    "noc_regions_cleaned.csv",
    "noc_regions_sample.csv",
    1000
)