import os
import json


print("So it worked... how interesting.")

mediasource = "../../Media"

medialist = []

files = os.listdir(mediasource)
files.sort()

for file in files:
    source = os.path.abspath(mediasource+'/'+file)
    # name = os.path.splitext(file)[0]
    name = file 

    mediadict = {
        "title":name,
        "source":source
    }

    medialist.append(mediadict)

json_object = json.dumps(medialist,indent=4)

with open('../playlist/mtv.json','w') as outfile:
    outfile.write(json_object)