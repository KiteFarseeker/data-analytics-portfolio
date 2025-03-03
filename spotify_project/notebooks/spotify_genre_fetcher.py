import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd

CLIENT_ID = "***"
CLIENT_SECRET = "***"

sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id = CLIENT_ID,
    client_secret = CLIENT_SECRET
))

data = pd.read_csv("spotify_streaming_history.csv")
def get_artist_genres(artist_name):
    try:
        result = sp.search(q="artist:" + artist_name, type = "artist", limit=1)
        items = result["artists"]["items"]
        if items:
            return items[0]["genres"]
        else:
            return ["Unknown"]
    except Exception as e:
        print("Error fetching genres for {artist_name}: {e}")
        return ["Error"]

data["master_metadata_album_artist_name"] = 
(data["master_metadata_album_artist_nameme"].str.strip().str.lower()
)
data["genres"] = data["master_metadata_album_artist_name"].apply(get_artist_genres)

data.to_csv("spotify_data_w_genres.csv", index = False)
print("Genres added successfully")
