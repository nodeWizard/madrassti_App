import re, os, hashlib
SRC='/tmp/claude-1000/-home-rawen-soltani-Documents-madrassti/219e6af0-6689-4d0c-94bc-1a151caad54a/scratchpad/screens'
OUT='/tmp/claude-1000/-home-rawen-soltani-Documents-madrassti/219e6af0-6689-4d0c-94bc-1a151caad54a/scratchpad/clean2'
os.makedirs(OUT,exist_ok=True)
def clean(s):
    s=re.sub(r'<helmet>.*?</helmet>','',s,flags=re.S)
    s=re.sub(r'\n{3,}','\n\n',s)
    return s.strip()
def ident(s):
    m=re.search(r'<title>(.*?)</title>',s)
    return m.group(1) if m else '?'
KNOWN={'Barre de navigation','Icône','Zitoun — mascotte','Pastille matière'}
rows=[]
for folder in sorted(os.listdir(SRC)):
    fp=os.path.join(SRC,folder)
    if not os.path.isdir(fp): continue
    for stem in sorted(os.listdir(fp)):
        sp=os.path.join(fp,stem)
        if not os.path.isdir(sp): continue
        parts=[]
        pg=os.path.join(sp,'page.html')
        if os.path.exists(pg):
            parts.append(clean(open(pg,encoding='utf-8',errors='replace').read()))
        kept=[];skipped=[]
        for f in sorted(os.listdir(sp)):
            if not f.startswith('frag_'): continue
            t=open(os.path.join(sp,f),encoding='utf-8',errors='replace').read()
            nm=ident(t)
            if nm in KNOWN:
                skipped.append(nm); continue
            kept.append(nm)
            parts.append(f'\n<!-- ===== SUBCOMPONENT: {nm} ===== -->\n'+clean(t))
        txt='\n'.join(parts)
        out=os.path.join(OUT,f'{folder}__{stem}.txt')
        open(out,'w').write(txt)
        rows.append((len(txt), f'{folder}__{stem}', kept, skipped))
for r in sorted(rows):
    print(f'{r[0]:>7}  {r[1]}\n          extra={r[2]}  reused={r[3]}')
print('TOTAL', sum(r[0] for r in rows))
