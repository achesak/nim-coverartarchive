# Cover Art Archive API wrapper

# Written by Adam Chesak.
# Code released under the MIT open source license.

# Import modules.
import httpclient
import json


# Define the types.
type TCoverArtData* = tuple[images : seq[TCoverArtImage], release : string]

type TCoverArtImage* = tuple[types : seq[string], front : bool, back : bool, edit : int, image : string, comment : string,
                             approved : bool, thumbnails : TCoverArtThumbnails, id : string]

type TCoverArtThumbnails* = tuple[large : string, small : string]
