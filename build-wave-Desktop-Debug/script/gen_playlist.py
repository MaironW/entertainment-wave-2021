import os
import json


print("So it worked... how interesting.")

mediasource = "../../Media"

categories = os.listdir(mediasource)
categories.sort()

for category in categories:
    medialist = []
    files = os.listdir(mediasource+'/'+category)
    files.sort()

    for file in files:
        source = os.path.abspath(mediasource+'/'+category+'/'+file)
        # name = os.path.splitext(file)[0]
        name = file

        mediadict = {
            "title":name,
            "source":source
        }

        medialist.append(mediadict)

    json_object = json.dumps(medialist,indent=4)

    with open('../playlist/'+category+'.json','w') as outfile:
        outfile.write(json_object)
