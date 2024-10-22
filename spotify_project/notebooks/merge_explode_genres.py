import pandas as pd
import ast

data = pd.read_csv("spotify_streaming_history.csv", low_memory=False)
artist_genres_df = pd.read_csv("artist_genre_mapping.csv")

data["master_metadata_album_artist_name"] = (data["master_metadata_album_artist_name"].str.strip().str.lower())

artist_genres_df = artist_genres_df.rename(columns={'artists': 'master_metadata_album_artist_name'})

merged_data = pd.merge(data, artist_genres_df, on="master_metadata_album_artist_name", how='left')

merged_data["genres"] = merged_data["genres"].apply(lambda x: ast.literal_eval(x) if isinstance(x, str) else x)

expanded_data = merged_data.explode("genres")
expanded_data["genres"] = expanded_data["genres"].fillna("Unknown")

expanded_data["master_metadata_album_artist_name"] = (expanded_data["master_metadata_album_artist_name"].str.title())
expanded_data["genres"] = (expanded_data["genres"].str.title())

expanded_data["minutes_played"] = expanded_data["ms_played"] / 60000

expanded_data.to_csv("spotify_genres_expanded_cleaned.csv", index=False)

print("Data cleaned, transformed, and exported to spotify_genres_expanded_cleaned.csv.")