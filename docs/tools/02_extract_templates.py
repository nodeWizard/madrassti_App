import re, json, base64, gzip, os

ROOT='/tmp/claude-1000/-home-rawen-soltani-Documents-madrassti/219e6af0-6689-4d0c-94bc-1a151caad54a/scratchpad/extract'
OUT='/tmp/claude-1000/-home-rawen-soltani-Documents-madrassti/219e6af0-6689-4d0c-94bc-1a151caad54a/scratchpad/screens'

def grab(s,t):
    m=re.search(r'<script type="__bundler/%s">(.*?)</script>'%t, s, re.S)
    return m.group(1) if m else None

def decomp(v):
    d=v['data']
    if v.get('compressed'): return gzip.decompress(base64.b64decode(d)).decode('utf-8',errors='replace')
    try: return base64.b64decode(d).decode('utf-8',errors='replace')
    except Exception: return d

summary=[]
for folder in sorted(os.listdir(ROOT)):
    fp=os.path.join(ROOT,folder)
    if not os.path.isdir(fp): continue
    for fn in sorted(os.listdir(fp)):
        if not fn.endswith('.html'): continue
        s=open(os.path.join(fp,fn),encoding='utf-8',errors='replace').read()
        man=grab(s,'manifest'); tpl=grab(s,'template')
        if not man: continue
        man=json.loads(man)
        stem=fn[:-5]
        od=os.path.join(OUT,folder,stem); os.makedirs(od,exist_ok=True)
        # template = page markup
        if tpl:
            t=json.loads(tpl)
            # strip the giant @font-face helmet block for readability but keep a copy
            open(os.path.join(od,'page.html'),'w').write(t)
        n_js=n_frag=0
        for k,v in man.items():
            mime=v.get('mime','')
            if mime=='text/javascript':
                n_js+=1
                open(os.path.join(od,f'script_{k[:8]}.js'),'w').write(decomp(v))
            elif mime=='text/html':
                n_frag+=1
                open(os.path.join(od,f'frag_{k[:8]}.html'),'w').write(decomp(v))
            elif mime=='text/css':
                open(os.path.join(od,f'style_{k[:8]}.css'),'w').write(decomp(v))
        summary.append((folder,stem,n_js,n_frag))
for x in summary: print(x)
