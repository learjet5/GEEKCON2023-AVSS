import json
import os
import requests
import sys

def download_file(url, local_filename):
    dirname = os.path.dirname(local_filename)
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192): 
                f.write(chunk)
    return local_filename

ossurl = "https://avss2023.oss-cn-shanghai.aliyuncs.com/"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"[*] python3 {sys.argv[0]} challengeid\nFor example, \npython3 {sys.argv[0]} KV1A7\n")
        sys.exit()

    challengeid = sys.argv[1]

    with open("./filelist.json", "r") as f:
        fl = json.load(f)
    
    if challengeid not in fl:
        print(f"{challengeid} not in filelist.json")
    
    print(f"{len(fl[challengeid])} files in total")
    for path in fl[challengeid]:
        print(f"Downloading {path}")
        download_file(ossurl+path, path)
    
    print("Done")
