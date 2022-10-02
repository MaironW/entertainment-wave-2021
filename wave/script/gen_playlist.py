import os
import json

for mode in ['mtv', 'vhs']:

    mediasource = '/home/pi/Videos/' + mode
    medialist = []

    for path, subdirs, files in os.walk(mediasource):
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
