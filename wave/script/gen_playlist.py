import os
import sys
import json

mediasource = sys.argv[1]
mode = sys.argv[2]

medialist = []

for path, subdirs, files in os.walk(mediasource):
    print(path,subdirs)
    for name in files:
        source = os.path.join(path, name)
        collection = os.path.basename(path)

        mediadict = {
            "title": name,
            "source": source,
            "collection": collection
        }

        medialist.append(mediadict)

json_object = json.dumps(medialist,indent=4)

with open('../playlist/'+mode+'.json','w') as outfile:
    outfile.write(json_object)
