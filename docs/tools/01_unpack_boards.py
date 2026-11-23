import re, json, base64, gzip, os, sys, html

# madrassti/madrasstiApp/docs/tools/ -> madrassti/mockups/
_HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(_HERE, '..', '..', '..', 'mockups')
OUT = '/tmp/claude-1000/-home-rawen-soltani-Documents-madrassti/219e6af0-6689-4d0c-94bc-1a151caad54a/scratchpad/extract'
os.makedirs(OUT, exist_ok=True)

def grab(s, t):
    m = re.search(r'<script type="__bundler/%s">(.*?)</script>' % t, s, re.S)
    return m.group(1) if m else None

index = {}
for fn in sorted(os.listdir(SRC)):
    if not fn.endswith('.html'):
        continue
    s = open(os.path.join(SRC, fn), encoding='utf-8').read()
    man = json.loads(grab(s, 'manifest'))
    tpl = grab(s, 'template')
    order = grab(s, 'page_order')
    base = re.sub(r'[^A-Za-z0-9]+', '_', fn[:-5]).strip('_')
    d = os.path.join(OUT, base)
    os.makedirs(d, exist_ok=True)
    # titles from template
    titles = {}
    if tpl:
        t = json.loads(tpl) if tpl.strip().startswith('"') else tpl
        for m in re.finditer(r'about:blank#([0-9a-f-]{36})\\?" title=\\?"(.*?)\\?" width=\\?"(\d+)\\?" height=\\?"(\d+)', t):
            titles[m.group(1)] = (m.group(2), m.group(3), m.group(4))
        open(os.path.join(d, '_template.txt'), 'w').write(t)
    if order:
        open(os.path.join(d, '_page_order.txt'), 'w').write(order)
    ents = []
    for uid, v in man.items():
        data = v['data']
        if v.get('compressed'):
            body = gzip.decompress(base64.b64decode(data))
        else:
            body = base64.b64decode(data) if v.get('mime','').startswith(('font','image')) else data.encode()
        title, w, h = titles.get(uid, (uid, '?', '?'))
        safe = re.sub(r'[^A-Za-z0-9]+', '_', title).strip('_')[:60] or uid[:8]
        mime = v.get('mime','')
        ext = '.html' if 'html' in mime else ('.woff2' if 'font' in mime else '.bin')
        name = f'{safe}{ext}'
        path = os.path.join(d, name)
        mode = 'wb'
        open(path, mode).write(body if isinstance(body, bytes) else body.encode())
        ents.append((title, w, h, mime, len(body), name))
    index[fn] = ents
    print('==', fn)
    for e in sorted(ents, key=lambda x: x[0]):
        if 'html' in e[3]:
            print(f'   {e[0]!r:55} {e[1]}x{e[2]}  {e[4]:>8} bytes  -> {e[5]}')
    nonhtml = [e for e in ents if 'html' not in e[3]]
    if nonhtml:
        print(f'   ({len(nonhtml)} non-html assets: {sorted(set(e[3] for e in nonhtml))})')
