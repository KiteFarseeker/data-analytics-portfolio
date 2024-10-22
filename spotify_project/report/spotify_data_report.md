# Spotify Streaming Analysis Project

## 1. Project Overview

Goal: The main objective of this project was to uncover music listening habits and how those changed over time.  This is merely a curiosity project as I am fairly certain I know which genres or artists will appear at the top of any list.  However, it would be interesting to find any outliers- songs or artists I didn't expect to see at the top.

Scope: The project involved
    - Cleaning and standardizing streaming data
    - Fetching genre data via Spotify API
    - Merging and restructuring data for visualization
    - Creating dashboards in Tableau for insights

## 2. Data Collection and Cleaning

Streaming data:
    - File name: spotify_streaming_data.csv
    - Size: 178,934 rows
    - Initially received as 13 JSON files
    - Key columns
        > master_metadata_track_name - Name of the track
        > master_metadata_album_artist_name - Artist name
        > ms_played - Playback time in milliseconds

API Data Retreival:
    - Used the Spotify API to fetch genre data for each artist
    - Challenges faced
        > API limits and response delays
        > Some artists returned empty lists or no genre data
        > Artist names required cleaning (eg. stripping spaces and lowercasing)

Preprocessing Steps:
    - Removed irrelevant columns (eg. IP address, username)
    - Standardized artist names by stripping spaces and converting all to lowercase
      - This was done to eliminate any potential deviation caused by extra spaces, or differences in capitalization
    - Converted playback time from milliseconds to minutes
      - This just makes it easier to compute mentally.  Folks are not commonly exposed to milliseconds

## 3. Challenges and Solutions

Challenge: API responses were inconsistent.  Some artists returned no genre data, and others returned an empty list ([])
Solution:
    - Differentiated between empty lists and missing artists
    - Tagged entries with missing genre data as "Unknown"
      - This was done in order to preserve the empty list returns.  It was important to me to see how much underground/indie music I listen to compared to more established artists

Challenge: Handling multiple genres per artist
Solution: 
    - Used Python's explode() function to split genre data into unique rows
    - Duplicated track information to maintain consistency in genre data

Challenge: Artist names were slightly different to the API data
Solution:
    - Standardized artist names by using strip() and lower() functions

## 4. Data Integration

Merging: 
    - Merged all 13 JSON files into a master data file
    - Artist genre map was saved periodically during API calls to ensure progress was preserved
    - Merged genre map data and master data file using a left join on "master_metadata_album_artist_name"

Exploding:
    - Exploded genre data using the explode() function to handle multiple genres per artist
    - Set a condition to fill NaN entries with "Unknown"

Reasons for Python:
    - Ultimately I went with using as the main tool to process all of the major steps for two key reasons.  First, I wanted to get more familiar with Python as a programming language.  While I've learned the basics, I haven't had many opportunities for practice, and this seemed like a great time for it.  Second, I was working with a rather large dataset.  Nearly 180k rows of data would have been tedious and time consuming to parse through Excel/Google Sheets

## 5. Visualization Planning and Insights

The final dataset was imported to Tableau for visualization.  Key takeaways include:
    - Genre distribution: Time spent listening to various genres
    - Artist and track popularity: Ranked top artists and tracks based on playtime
    - Unknown genre analysis: Compare time spent listening to known artists vs. underground/indie artists
      - The reason to use Tableau is that it's fairly user-friendly and has a wide array of built-in tools for further data manipulation if needed.  It's also pretty easy to share dashboards, all I need to share is a link

Possible future insights:
    - Seasonal trends in listening habits
    - Genre distribution over time

## 6. Lessons Learned and Improvements

Lessons learned:
    - API rate limits can be tricky to work around
      - For my first foray into APIs, I learned very quickly that you need to account for things like rate limitations, as it became a primary challenge throughout the project.  Learning to process the API calls in batches, periodic saving to preserve progress in case of a mishap, and multiple layers of error handling were critical in overcomming these challenges
    - Standardizing data format to ensure smooth operation

Future improvements:
    - Optimize API script to handle larger batches
    - Implement data validation early to prevent artist name mismatch
    - Explore other ways to enrich data, such as album popularity

## 7. Conclusion and Next Steps

Conclusion:
    - This project showed how my Spotify streaming habits changed and evolved over time.  This project also reinforced my skills for:
      - API scripting
      - Cleaning and processing larger datasets
      - Building interactive dashboards to extract insights

Next steps:
    - Finalizing Tableau dashboards to share insights
    - Consider other data sources for further enrichment

Closing note:
    - This was a great exersize for my data analytics skills.  As they say "Use it or lose it", and I'd rather not go rusty before I've even entered the field.  I intend to work on more projects that will allow me to enhance the various skills I used in this project (Python, APIs, Tableau, and more) and maybe even build upon other skills I'll need in the field as well (such as SQL)

## 8. Appendix

GitHub Repository: https://github.com/KiteFarseeker/Spotify-Streaming-Project
Tableau Dashboard: https://public.tableau.com/views/SpotifyAnalysisProcess/Sheet1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

Tools used:
    - Python (pandas, requests)
    - Spotify API
    - Tableau
    - Excel (for quick data checks)