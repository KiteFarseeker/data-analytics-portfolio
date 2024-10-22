import os
import json
import pandas as pd

directory = r"C:C:\Users\User\Documents\Data Projects\Spotify Project\Spotify Extended Streaming History"

all_data = []

for filename in os.listdir(directory):
    if filename.endswith(".json"):
        file_path = os.path.join(directory, filename)
        if os.path.getsize(file_path) == 0:
                print(f"Skipping empty file: {filename}")
                continue
        
    with open(os.path.join(directory, filename), encoding="ISO-8859-1") as file:
        try:
            data = json.load(file)
            all_data.extend(data)
        except json.JSONDecodeError as e:
             print(f"Error decoding {filename}: {e}")

if all_data:
    df = pd.DataFrame(all_data)
    output_file_path = r"C:\Users\User\Desktop\spotify_streaming_history.csv"
    df.to_csv(output_file_path, index = False)
    print("All JSON files have been combined and saved as spotify_streaming_history.csv")
else:
    print("No valid JSON file")