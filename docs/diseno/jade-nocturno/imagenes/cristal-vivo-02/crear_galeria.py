#!/usr/bin/env python3
"""Galería offline para revisar los SVG/PNG del kit Jade Nocturno · Cristal Vivo 02.
Usar: python fuente/crear_galeria.py /ruta/al/kit (requiere Pillow).
"""
import csv, json, math, sys, html
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

def font(size,bold=False):
    paths=['/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf' if bold else '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf']
    for p in paths:
        if Path(p).exists():return ImageFont.truetype(p,size)
    return ImageFont.load_default()

def generate(root):
    root=Path(root)
    rows=list(csv.DictReader((root/'manifiesto.csv').open(encoding='utf8')))
    assert len(rows)==401
    out=root/'galeria';out.mkdir(exist_ok=True)
    families={}
    for row in rows: families.setdefault(row['id'],[]).append(row)
    for fam,items in families.items():
        cols=4; cellw,cellh=286,250; margin=20; h=100+math.ceil(len(items)/cols)*cellh+30
        w=4*cellw+2*margin
        im=Image.new('RGBA',(w,h),(5,22,19,255));d=ImageDraw.Draw(im)
        d.text((margin,25),f'{fam}  ·  {items[0]["familia"].replace("_"," ")}',font=font(24,True),fill=(232,236,214))
        d.text((margin,60),f'Propuesta 02 / Cristal vivo  •  {len(items)} recursos  •  sin aprobación individual',font=font(12),fill=(116,218,176))
        for j,row in enumerate(items):
            x=margin+(j%cols)*cellw;y=100+(j//cols)*cellh
            d.rounded_rectangle((x+4,y+2,x+cellw-6,y+cellh-9),radius=16,fill=(9,43,34,255),outline=(93,131,110,255),width=1)
            png=Image.open(root/row['png']).convert('RGBA');png.thumbnail((cellw-34,155),Image.Resampling.LANCZOS)
            im.alpha_composite(png,(x+int((cellw-png.width)/2),y+int((170-png.height)/2)+8))
            d.text((x+16,y+180),row['componente'].replace('_',' ')[:26],font=font(13,True),fill=(235,227,197))
            d.text((x+16,y+203),f"{row['variante'].replace('_',' ')[:25]}  ·  {row['ancho']}×{row['alto']}",font=font(11),fill=(141,208,180))
        im.convert('RGB').save(out/(fam.lower()+'.jpg'),quality=85,optimize=True)
    # Todo embebido y offline, sin dependencias de red; texto/números son etiquetas de revisión.
    data=json.dumps([{k:r[k] for k in ['id','familia','componente','variante','png','svg','ancho','alto']} for r in rows],ensure_ascii=False,separators=(',',':')).replace('</','<\\/')
    html_text='''<!DOCTYPE html>
<html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Kit visual · Cristal vivo 02 · Karmany Monsta</title>
<style>
:root{--bg:#061811;--panel:#0b281f;--ink:#e7efd9;--mint:#73edb2;--gold:#d9bf81;--muted:#9fbcab}
*{box-sizing:border-box}body{margin:0;color:var(--ink);background:radial-gradient(ellipse at top,#123d32,#061811 60%);font:14px/1.45 system-ui, sans-serif}a{color:var(--mint);text-decoration:none}a:hover{text-decoration:underline}
header{padding:28px max(20px,4vw);border-bottom:1px solid #567a61;background:linear-gradient(90deg,#081b18dd,#102d23bb);position:sticky;top:0;z-index:3;backdrop-filter:blur(14px)}h1{font:30px/1.1 Georgia,serif;margin:0 0 8px;letter-spacing:1px}header p{margin:0;color:var(--muted)}.accent{color:var(--mint);font-weight:700}main{max-width:1640px;margin:auto;padding:22px 4vw 100px}.toolbar{display:flex;gap:12px;flex-wrap:wrap;align-items:center;position:sticky;top:116px;z-index:2;background:#061811e8;padding:14px 0;border-bottom:1px solid #275141}input,select{padding:12px;border:1px solid #436c59;border-radius:11px;background:#102f27;color:white;font:inherit;max-width:100%;width:270px}.stats{margin-left:auto;color:var(--gold);white-space:nowrap}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));gap:17px;margin:24px 0}.tile{border:1px solid #426c54;background:linear-gradient(130deg,#103b2dcc,#09261fcf);border-radius:14px;overflow:hidden;box-shadow:0 8px 25px #0003}.tile img{display:block;width:100%;height:155px;object-fit:contain;padding:13px;background:radial-gradient(ellipse,#194f3c,#091c17 72%);cursor:zoom-in}.tile .meta{padding:13px 14px 16px}.tag{font:11px system-ui,sans-serif;letter-spacing:1px;color:var(--gold)}.tile strong{display:block;margin:6px 0;font-size:15px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.variant{color:var(--muted);min-height:20px}.links{display:flex;gap:18px;margin-top:11px}.links a{border:1px solid #337659;border-radius:8px;padding:4px 9px}.note{padding:13px 16px;border-left:3px solid var(--gold);color:var(--muted);background:#08261eb5}dialog{background:#051c16;border:1px solid #a8d2a8;color:var(--ink);border-radius:16px;max-width:min(90vw,1060px);padding:22px}dialog::backdrop{background:#000d}dialog img{max-width:86vw;max-height:67vh;width:auto;height:auto;display:block;margin:12px auto}button{background:#195743;color:#efffee;border:1px solid #a4d1a6;padding:9px 14px;border-radius:8px;cursor:pointer}footer{color:var(--muted);text-align:center;margin-top:32px}@media(max-width:680px){.toolbar{top:128px}h1{font-size:24px}input,select{width:100%}.stats{margin-left:0}}
</style></head><body><header><h1>KARMANY MONSTA <span style="color:var(--mint)">/ JADE NOCTURNO</span></h1><p><span class="accent">PROPUESTA 02 — CRISTAL VIVO</span> · Biblioteca visual para revisión, sin integración al juego</p></header>
<main><div class="note">401 exportaciones SVG + PNG, organizadas en 53 familias. Algunas superficies comparten geometría reutilizable: cada archivo no implica una ilustración única. Las cifras y textos de juego deben seguir siendo nodos dinámicos Godot.</div>
<div class="toolbar"><input id="find" type="search" placeholder="Buscar componente o variante…" aria-label="Buscar componente"><select id="familia" aria-label="Filtrar por familia"><option value="">Todas las familias</option></select><span class="stats" id="count">401 recursos</span></div>
<div id="grid" class="grid"></div><dialog id="preview"><button id="close">Cerrar ×</button><div id="previewTitle"></div><img id="previewImage" alt="Recurso ampliado"/></dialog><footer>Karmany Monsta Android · Kit Cristal Vivo 02 · Fuentes SVG editables · Propuesta pendiente de aprobación</footer></main>
<script>const ITEMS=__DATA__;const grid=document.getElementById('grid'),sel=document.getElementById('familia'),find=document.getElementById('find'),count=document.getElementById('count');
const opt=new Map;ITEMS.forEach(i=>opt.set(i.id,i.familia));Array.from(opt.entries()).sort().forEach(([id,f])=>{const e=document.createElement('option');e.value=id;e.textContent=id+' · '+f.replaceAll('_',' ');sel.append(e)});
function node(type,cls,txt){const el=document.createElement(type);if(cls)el.className=cls;if(txt!==undefined)el.textContent=txt;return el}
function draw(){grid.replaceChildren();const q=find.value.trim().toLowerCase(),f=sel.value;let shown=0;
for(const i of ITEMS){if(f && i.id!==f)continue;if(q&&!`${i.id} ${i.familia} ${i.componente} ${i.variante}`.toLowerCase().includes(q))continue;shown++;
const card=node('article','tile');const img=document.createElement('img');img.loading='lazy';img.src=i.png;img.alt=i.id+' '+i.componente;img.addEventListener('click',()=>{document.getElementById('previewImage').src=i.png;document.getElementById('previewTitle').textContent=i.id+' / '+i.componente+' / '+i.variante;document.getElementById('preview').showModal()});card.append(img);
const meta=node('div','meta');meta.append(node('div','tag',i.id));meta.append(node('strong','',i.componente.replaceAll('_',' ')));meta.append(node('div','variant',i.variante.replaceAll('_',' ')+' · '+i.ancho+'×'+i.alto));
const links=node('div','links');for(const [name,path] of [['SVG',i.svg],['PNG',i.png]]){const a=node('a','',name);a.href=path;a.target='_blank';a.rel='noopener';links.append(a)}meta.append(links);card.append(meta);grid.append(card)}count.textContent=shown+' / '+ITEMS.length+' recursos';}
find.addEventListener('input',draw);sel.addEventListener('change',draw);document.getElementById('close').addEventListener('click',()=>document.getElementById('preview').close());draw();
</script></body></html>'''.replace('__DATA__',data)
    (root/'GALERIA_VISUAL.html').write_text(html_text,encoding='utf-8')
    return len(families)
if __name__=='__main__':
    print('Galerías de familia:',generate(Path(sys.argv[1]) if len(sys.argv)>1 else Path.cwd()))
