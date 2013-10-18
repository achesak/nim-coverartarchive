# Cover Art Archive API wrapper

# Written by Adam Chesak.
# Code released under the MIT open source license.

# Import modules.
import httpclient
import json
import strutils


# Define the types.
type TCoverArtThumbnails* = tuple[large : string, small : string]

type TCoverArtImage* = tuple[types : seq[string], front : bool, back : bool, edit : int, image : string, comment : string,
                             approved : bool, thumbnails : TCoverArtThumbnails, id : string]

type TCoverArtData* = tuple[images : seq[TCoverArtImage], release : string]


proc getCoverArt*(mbid : string): TCoverArtData =
    ## Gets the cover art data for the MusicBrainz release with id mbid.
    
    # Create the return object.
    var coverArt : TCoverArtData
    
    # Get the data.
    var response : string = getContent("http://coverartarchive.org/release/" & mbid)
    
    # Convert the data to JSON.
    var jsonData : PJsonNode = parseJson(response)
    
    # Set the fields.
    coverArt.release = jsonData["release"].str
    var coverImgSeq = newSeq[TCoverArtImage](len(jsonData["images"]))
    for i in 0..len(jsonData["images"]) - 1:
        
        # Create the image objects.
        var coverImg : TCoverArtImage
        if $jsonData["images"][i]["front"] == "true":
            coverImg.front = true
        else:
            coverImg.front = false
        if $jsonData["images"][i]["back"] == "true":
            coverImg.back = true
        else:
            coverImg.back = false
        coverImg.edit = parseInt($jsonData["images"][i]["edit"])
        coverImg.image = jsonData["images"][i]["image"].str
        coverImg.comment = jsonData["images"][i]["comment"].str
        if $jsonData["images"][i]["approved"] == "true":
            coverImg.approved = true
        else:
            coverImg.approved = false
        coverImg.id = jsonData["images"][i]["id"].str
        var coverThumb : TCoverArtThumbnails
        coverThumb.large = jsonData["images"][i]["thumbnails"]["large"].str
        coverThumb.small = jsonData["images"][i]["thumbnails"]["small"].str
        coverImg.thumbnails = coverThumb
        var coverTypes = newSeq[string](len(jsonData["images"][i]["types"]))
        for j in 0..len(jsonData["images"][i]["types"]) - 1:
            coverTypes[j] = jsonData["images"][i]["types"][j].str
        coverImg.types = coverTypes
        
        # Append the image object.
        coverImgSeq[i] = coverImg
    
    # Add the sequence of images.
    coverArt.images = coverImgSeq
    
    # Return the cover art data.
    return coverArt
