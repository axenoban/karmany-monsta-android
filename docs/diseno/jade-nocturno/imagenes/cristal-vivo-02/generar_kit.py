#!/usr/bin/env python3
"""Karmany Monsta Android — Jade Nocturno / Cristal Vivo (propuesta 02).
Produce 401 SVG editables + 401 PNG de revisión, guías, manifiestos y controles QA.
No modifica contenido canónico, gameplay, scripts existentes ni assets activos.
Requisitos: pip install cairosvg pillow (también disponibles en entorno de entrega).
Uso: python generate_kit.py --output /ruta/kit [--background imagen.png]
"""
from __future__ import annotations
import argparse, csv, hashlib, math, shutil, sys, textwrap, xml.etree.ElementTree as ET
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import cairosvg

BLOCKS={
 'BASE':'01-kit-maestro','CTRL':'01-kit-maestro',
 'ICO':'02-iconos-mapa-combate',
 'PANT':'03-equipo-y-progresion',
 'FX':'04-pantallas-y-situaciones'
}
FAMILIES=[
 ('BASE','01','Identidad',6,'titulo,emblema,sello,cabecera,distintivo,subtitulo'),
 ('BASE','02','Tipografia',8,'titulo_principal,titulo_seccion,nombre,valor,descripcion,ayuda,numero,accesible'),
 ('BASE','03','Marcos',12,'rectangular,cuadrado,retrato,miniatura,ventana,tarjeta,marco_doble,contenido,cabecera,esquina,placa,seleccion'),
 ('BASE','04','Ornamentacion',9,'cristal,hoja,rama,filigrana,separador,diamante,esquina,onda,sello'),
 ('BASE','05','Materiales',8,'tinta,esmeralda,jade,bruma,cristal,oro,marfil,bloqueado'),
 ('BASE','06','Paneles',14,'principal,principal_amplio,informacion,informacion_larga,lateral,lateral_bajo,franja,franja_estrecha,ventana,ventana_pequena,tarjeta,tarjeta_vertical,cabecera,dialogo'),
 ('BASE','07','Fondos',8,'menu,regiones,mapa,exploracion,combate,equipo,libro,ajustes'),
 ('CTRL','01','Botones_principales',6,'normal,pulsado,seleccionado,enfocado,deshabilitado,bloqueado'),
 ('CTRL','02','Botones_secundarios',6,'normal,pulsado,seleccionado,enfocado,deshabilitado,bloqueado'),
 ('CTRL','03','Botones_combate',18,'golpe,proteccion,insignia'),
 ('CTRL','04','Botones_icono',30,'volver,cerrar,ajustes,informacion,ayuda,siguiente'),
 ('CTRL','05','Barra_navegacion',15,'equipo,libro,bestiario'),
 ('CTRL','06','Pestanas_filtros',8,'normal,pulsado,seleccionado,enfocado,deshabilitado,bloqueado,abierto,cerrado'),
 ('CTRL','07','Interruptores',8,'sonido,vibracion,texto_grande,movimiento_reducido'),
 ('CTRL','08','Deslizadores',6,'pista,relleno,tirador,volumen,deshabilitado,enfocado'),
 ('CTRL','09','Listas_desplazables',6,'separador,barra,flecha_superior,flecha_inferior,indicador_izquierdo,indicador_derecho'),
 ('CTRL','10','Selectores_tecnicos',6,'desplegable,numero_menos,numero_mas,seleccion,deshabilitado,foco'),
 ('ICO','01','Navegacion',6,'volver,cerrar,ajustes,ayuda,informacion,flecha'),
 ('ICO','02','Secciones',6,'equipo,coleccion,libro,bestiario,entrenador,resonancias'),
 ('ICO','03','Combate',5,'golpe,proteccion,insignia,cambio,resonancia'),
 ('ICO','04','Estadisticas',6,'vida,ataque,defensa,velocidad,nivel,experiencia'),
 ('ICO','05','Exploracion',5,'stamina,localizacion,ruta,entrada,recompensa'),
 ('ICO','06','Estados',6,'activo,reserva,seleccionado,bloqueado,completado,disponible'),
 ('ICO','07','Ajustes',5,'sonido,volumen,vibracion,texto,movimiento_reducido'),
 ('PANT','01','Inicio',6,'cabecera,menu,continuar,nueva_partida,confirmacion,fondo'),
 ('PANT','02','Regiones',6,'tarjeta,progreso,disponible,bloqueado,seleccion,detalle'),
 ('PANT','03','Mapa',8,'marcador,conexion,disponible,completado,bloqueado,seleccion,stamina,cabecera'),
 ('PANT','04','Localizacion',7,'ficha,ilustracion,nombre,coste,datos,acceso,marco'),
 ('PANT','05','Exploracion',6,'hud,contexto,accion,aviso,transicion,marco'),
 ('PANT','06','Combate_cabecera',7,'retrato,vida,nivel,turno,oponente,equipo,reserva'),
 ('PANT','07','Combate_acciones',7,'golpe,proteccion,insignia,entrenador,equipo,detalles,marco'),
 ('PANT','08','Combate_ventanas',7,'detalle,tecnicas,entrenador,resonancia,miembro,opciones,cierre'),
 ('PANT','09','Resultados',6,'victoria,derrota,recompensa,experiencia,nivel,continuacion'),
 ('PANT','10','Vinculacion',6,'libro,intento,accion,exito,fallo,escape'),
 ('PANT','11','Equipo',7,'protagonista,nombre,activo,reserva,estadisticas,acciones,tarjeta'),
 ('PANT','12','Selector_equipo',7,'retrato,seleccionado,hueco,coleccion,lista,activo,reserva'),
 ('PANT','13','Coleccion',7,'tarjeta,resumen,seleccion,incorporar,filtro,detalle,lista'),
 ('PANT','14','Bestiario',7,'especie,silueta,filtro,rareza,registro,ficha,lista'),
 ('PANT','15','Libro',7,'ilustracion,nivel,probabilidad,mejora,requisitos,confirmacion,marco'),
 ('PANT','16','Perfil_Ezel',6,'retrato,identidad,nivel,experiencia,equipo,resonancia'),
 ('PANT','17','Arbol_resonancias',7,'nodo,conexion,aprendido,disponible,bloqueado,ficha,navegacion'),
 ('PANT','18','Resonancias_equipadas',6,'hueco,seleccion,equipar,retirar,lista,detalle'),
 ('PANT','19','Configuracion',6,'grupo,interruptor,deslizador,separador,ayuda,confirmacion'),
 ('PANT','20','Prologo_tutorial',6,'dialogo,retrato,avanzar,omitir,ayuda,paso'),
 ('PANT','21','Diagnostico_laboratorio',6,'panel,formulario,modo_qa,mensaje,confirmacion,seleccion'),
 ('FX','01','Ventanas',6,'inicio_01,inicio_02,inicio_03,cierre_01,cierre_02,cierre_03'),
 ('FX','02','Pulsacion',6,'normal,pulsado,rebote,eco,confirmado,deshabilitado'),
 ('FX','03','Seleccion',6,'anillo,halo,brillo,borde,particulas,quieto'),
 ('FX','04','Barras',6,'vida_100,vida_75,vida_50,vida_25,xp_50,xp_100'),
 ('FX','05','Celebraciones',7,'recompensa_01,recompensa_02,nivel_01,nivel_02,vinculacion_01,vinculacion_02,quieto'),
 ('FX','06','Avisos',7,'informacion,confirmacion,error,bloqueado,guardado,advertencia,quieto'),
 ('FX','07','Transiciones',6,'exploracion_01,exploracion_02,combate_01,combate_02,resultados_01,resultados_02'),
 ('FX','08','Accesibilidad',6,'estatico,contraste_alto,borde_doble,sin_barrido,sin_brilLo,pulso_estatico')
]
assert len(FAMILIES)==53 and sum(x[3] for x in FAMILIES)==401
FAMILIES_BY_ID={f'JN-{a}-{b}':(a,b,c,n,s) for a,b,c,n,s in FAMILIES}
BG='#061913'; INK='#092820'; JADE='#4cf6ae'; GOLD='#daba75'; IVORY='#f2eedc'
STATES=['normal','pulsado','seleccionado','enfocado','deshabilitado','bloqueado']

def slugify(s):
 import re
 return re.sub(r'[^a-z0-9_]+','_',s.lower()).strip('_')

def mode_for(family,variant,index):
 a,b,c,n,s=family
 if a=='ICO':return 'icon'
 if a=='FX':return 'bar' if b=='04' else 'fx'
 if a=='CTRL':
  return {'01':'button','02':'button','03':'button','04':'icon_button','05':'nav','06':'button','07':'toggle','08':'bar','09':'ornament','10':'button'}[b]
 if a=='BASE':
  return {'01':'ornament','02':'panel','03':'frame','04':'ornament','05':'panel','06':'panel','07':'background'}[b]
 if 'Mapa'==c or b=='17':return 'marker' if variant in ('marcador','nodo','seleccion','disponible','completado','bloqueado','aprendido') else 'screen'
 if b in ('06','12','14','16') and variant in ('retrato','especie','silueta','protagonista'):return 'frame'
 if variant in ('vida','experiencia','probabilidad','progreso','stamina','nivel'):return 'bar'
 return 'screen'

def dimensions(mode,variant):
 if mode=='icon':return (160,160)
 if mode=='icon_button':return (176,176)
 if mode=='toggle':return (240,132)
 if mode=='nav':return (420,150)
 if mode=='button':return (520,150)
 if mode=='bar':return (800,94)
 if mode=='marker':return (170,170)
 if mode=='ornament':return (440,160)
 if mode=='fx':return (640,380)
 if mode=='frame':return (512,512)
 if mode=='background':return (960,540)
 if mode=='screen':return (960,540)
 return (850,520)

def tint_and_state(variant,idx,group):
 state = variant if variant in STATES else (STATES[idx%6] if group=='FX' else 'normal')
 if state=='deshabilitado': return state,'#788e86','#626b65','#33443e','#152a24'
 if state=='bloqueado':return state,'#b1a28a','#6b6c58','#394b43','#15201c'
 if state in ('seleccionado','enfocado'):return state,'#baffde','#cce7ad','#2cf3ad','#0a4635'
 if state=='pulsado':return state,'#80e9bb','#d7ba73','#18a77b','#0b3b30'
 return state,'#72deab','#d7b879','#13a77b','#082d24'

def corner_cut(w,h,r=None):
 r = r or max(9,min(w,h)*0.10)
 return f'M {r:.1f} 4 L {w-r-8:.1f} 4 L {w-4:.1f} {r+5:.1f} L {w-4:.1f} {h-r-7:.1f} L {w-r-8:.1f} {h-4:.1f} L {r:.1f} {h-4:.1f} L 4 {h-r-8:.1f} L 4 {r+6:.1f} Z'

def icon_shape(key,x,y,r,stroke='#f2eedc'):
 # Conjunto de símbolos SVG propios, geometría procedural sencilla, sin dependencias de iconos externos.
 paths={
 'volver':'M 0 -25 L -28 0 L 0 25 M -25 0 L 31 0',
 'cerrar':'M -23 -23 L 23 23 M 23 -23 L -23 23',
 'siguiente':'M -8 -25 L 20 0 L -8 25 M -26 0 L 18 0',
 'flecha':'M -20 -22 L 7 0 L -20 22',
 'ayuda':'M -13 -16 C -9 -31 17 -31 21 -13 C 25 0 5 4 3 13 M 3 24 L 3 25',
 'informacion':'M 0 -14 L 0 25 M 0 -28 L 0 -26',
 'ajustes':'M -16 -16 L 16 16 M 16 -16 L -16 16 M 0 -31 L 0 31 M -31 0 L 31 0',
 'equipo':'M -31 20 L -30 -5 Q -20 -30 0 -25 Q 20 -30 30 -5 L 31 20 Q 0 29 -31 20 Z M -18 -10 L 0 3 L 18 -10',
 'coleccion':'M -28 -22 L -5 -30 L 26 -22 L 26 24 L -5 31 L -28 24 Z M -5 -30 L -5 31 M -28 -22 L -5 -11 L 26 -22',
 'libro':'M -33 -25 Q -16 -30 0 -18 Q 16 -30 33 -25 L 33 24 Q 15 18 0 30 Q -15 18 -33 24 Z M 0 -18 L 0 30',
 'bestiario':'M -27 9 C -34 -15 -11 -25 -9 -6 M -7 8 C -15 -20 13 -23 9 -4 M 13 10 C 14 -19 35 -10 26 11 M -25 21 Q -9 4 0 9 Q 9 4 25 21 Q 34 38 0 29 Q -34 38 -25 21 Z',
 'entrenador':'M 0 -29 A 14 14 0 1 1 -1 -29 Z M -29 26 Q -26 2 0 4 Q 26 2 29 26',
 'resonancias':'M 0 -30 L 18 -9 L 4 28 L -6 3 L -24 12 Z M 1 -27 L -6 3 L 18 -9',
 'golpe':'M -28 25 L -8 -29 M -6 27 L 14 -30 M 15 25 L 32 -24',
 'proteccion':'M 0 -33 L 26 -21 L 22 8 Q 15 27 0 34 Q -15 27 -22 8 L -26 -21 Z M 0 -20 L 0 21',
 'insignia':'M 0 -33 L 12 -7 L 0 31 L -12 -7 Z M -22 -7 L -10 3 L -4 28 L -27 7 Z M 22 -7 L 10 3 L 4 28 L 27 7 Z',
 'cambio':'M -27 -13 L 18 -13 L 10 -23 M 18 -13 L 10 -3 M 27 13 L -18 13 L -10 23 M -18 13 L -10 3',
 'vida':'M 0 26 C -39 5 -32 -27 -9 -25 Q 0 -16 0 -16 Q 14 -32 27 -19 C 44 -2 18 18 0 26 Z',
 'ataque':'M -23 25 L 24 -23 M 4 -26 L 28 -28 L 25 -3 M -29 22 L -8 28',
 'defensa':'M 0 -32 L 25 -22 L 20 9 Q 12 24 0 33 Q -12 24 -20 9 L -25 -22 Z',
 'velocidad':'M -26 2 L -6 -27 L 9 -6 L 29 -28 L 14 12 L -7 11 L -22 30',
 'nivel':'M -26 29 L -26 -6 L 0 -27 L 26 -6 L 26 29 Z M -8 -7 L 8 -7 M 0 -16 L 0 4',
 'experiencia':'M 0 -31 L 7 -9 L 30 -9 L 12 5 L 19 30 L 0 15 L -19 30 L -12 5 L -30 -9 L -7 -9 Z',
 'stamina':'M 10 -31 L -17 3 L 3 3 L -10 31 L 23 -11 L 1 -11 Z',
 'localizacion':'M 0 -31 C 34 -31 34 6 0 31 C -34 6 -34 -31 0 -31 Z M 0 -16 A 10 10 0 1 0 0 4 A 10 10 0 1 0 0 -16 Z',
 'ruta':'M -29 18 Q -2 18 -7 -9 Q -7 -23 9 -17 Q 27 -9 29 -24 M 21 -22 L 29 -30 L 34 -19',
 'entrada':'M -20 30 L -20 -25 L 20 -25 L 20 30 M -7 30 L -7 -2 L 9 -2 L 9 30',
 'recompensa':'M 0 -33 L 27 -18 L 27 17 L 0 33 L -27 17 L -27 -18 Z M -27 -18 L 0 -1 L 27 -18 M 0 -1 L 0 33',
 'activo':'M -26 0 L -6 21 L 27 -25',
 'reserva':'M -24 -18 L 24 -18 L 24 19 L -24 19 Z M -14 -5 L 14 -5 M -14 6 L 14 6',
 'seleccionado':'M 0 -33 L 27 -2 L 0 31 L -27 -2 Z',
 'bloqueado':'M -20 -5 L 20 -5 L 20 27 L -20 27 Z M -12 -5 L -12 -16 Q -12 -35 0 -35 Q 12 -35 12 -16 L 12 -5',
 'completado':'M -26 0 L -8 17 L 27 -23',
 'disponible':'M 0 -29 A 29 29 0 1 1 -0.1 -29 Z M 0 -16 L 0 0 L 14 0',
 'sonido':'M -29 -11 L -15 -11 L 0 -26 L 0 25 L -15 11 L -29 11 Z M 11 -14 Q 29 0 11 14',
 'volumen':'M -25 -10 L -11 -10 L -1 -25 L -1 25 L -11 10 L -25 10 Z M 8 -21 Q 31 -1 8 21 M 17 -29 Q 46 0 17 29',
 'vibracion':'M -13 -30 L 13 -30 L 13 30 L -13 30 Z M -23 -22 Q -34 -2 -23 19 M 23 -22 Q 34 -2 23 19',
 'texto':'M -31 -22 L 31 -22 M 0 -22 L 0 28 M -19 28 L 19 28',
 'movimiento_reducido':'M -24 0 A 24 24 0 1 1 23 1 M -30 29 L 30 -29',
 }
 key=key.lower().replace('protección','proteccion')
 path=paths.get(key) or paths.get(key.split('_')[0]) or paths['resonancias']
 scale=r/40
 accent= f'<circle cx="0" cy="0" r="34" stroke="{stroke}" stroke-opacity=".2" stroke-width="1" fill="none"/>' if key in ('disponible','activo') else ''
 return f'<g data-icon="{key}" transform="translate({x:.1f} {y:.1f}) scale({scale:.4f})" stroke="{stroke}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" fill="none">{accent}<path d="{path}"/></g>'

def defs(light,gold,core):
 return f'''<defs>
 <linearGradient id="base" x1="0" y1="0" x2=".85" y2="1"><stop stop-color="#071b17"/><stop offset=".43" stop-color="{core}"/><stop offset="1" stop-color="#061812"/></linearGradient>
 <linearGradient id="glass" x1="0" y1="0" x2="1" y2="1"><stop stop-color="#5defbb" stop-opacity=".24"/><stop offset=".45" stop-color="#008a67" stop-opacity=".05"/><stop offset="1" stop-color="#70ffbc" stop-opacity=".20"/></linearGradient>
 <linearGradient id="edge" x1="0" y1="0" x2="1" y2="0"><stop stop-color="{gold}"/><stop offset=".25" stop-color="{light}"/><stop offset=".66" stop-color="#207b58"/><stop offset="1" stop-color="{gold}"/></linearGradient>
 <linearGradient id="bar" x1="0" x2="1" y1="0" y2=".2"><stop stop-color="#138b64"/><stop offset=".45" stop-color="{light}"/><stop offset="1" stop-color="#0b9a6b"/></linearGradient>
 <radialGradient id="aura"><stop stop-color="{light}" stop-opacity=".30"/><stop offset="1" stop-color="{light}" stop-opacity="0"/></radialGradient>
 </defs>'''

def crystalline(w,h,light,opacity=1):
 return f'''<g opacity="{opacity}">
 <path d="M {w*.06:.1f} {h*.75:.1f} C {w*.17:.1f} {h*.50:.1f} {w*.36:.1f} {h*.98:.1f} {w*.56:.1f} {h*.75:.1f} S {w*.84:.1f} {h*.90:.1f} {w*.96:.1f} {h*.63:.1f}" fill="none" stroke="{light}" stroke-opacity=".21" stroke-width="{h*.035:.1f}"/>
 <path d="M {w*.03:.1f} {h*.82:.1f} Q {w*.20:.1f} {h*.55:.1f} {w*.40:.1f} {h*.78:.1f} T {w*.85:.1f} {h*.73:.1f}" fill="none" stroke="#baffdf" stroke-opacity=".40" stroke-width="{max(1,h*.012):.2f}"/>
 <path d="M {w*.72:.1f} {h*.13:.1f} L {w*.85:.1f} {h*.25:.1f} L {w*.91:.1f} {h*.08:.1f} M {w*.11:.1f} {h*.14:.1f} L {w*.20:.1f} {h*.29:.1f} L {w*.28:.1f} {h*.15:.1f}" fill="none" stroke="{light}" stroke-opacity=".09" stroke-width="1.8"/>
 </g>'''

def shard(x,y,r,color='#97ffd1'):
 return f'<path d="M {x:.1f} {y-r:.1f} L {x+r*.6:.1f} {y-r*.16:.1f} L {x:.1f} {y+r:.1f} L {x-r*.6:.1f} {y-r*.16:.1f} Z" stroke="{color}" stroke-width="1.3" fill="#0eaa7a" fill-opacity=".65"/><path d="M {x:.1f} {y-r:.1f} L {x:.1f} {y+r:.1f}" stroke="#d1ffdf" stroke-opacity=".7"/>'

def outline(w,h,light,gold,core,selected=False,compact=False):
 p=corner_cut(w,h)
 body=f'''<path d="{p}" fill="url(#base)" stroke="{light}" stroke-opacity=".30" stroke-width="8"/>
 <path d="{p}" fill="url(#glass)" stroke="url(#edge)" stroke-width="{5 if selected else 3.5}"/>
 <path d="{p}" fill="none" stroke="{light}" stroke-opacity="{.30 if selected else .12}" stroke-width="14"/>
 <path d="M {w*.10:.1f} {h*.12:.1f} L {w*.88:.1f} {h*.12:.1f}" stroke="#d7ffdf" stroke-opacity=".34" stroke-width="1.7"/>
 <path d="M {w*.07:.1f} {h*.82:.1f} L {w*.13:.1f} {h*.94:.1f} L {w*.27:.1f} {h*.94:.1f}" stroke="{gold}" stroke-width="{max(2,h*.03):.2f}" fill="none"/>
 <path d="M {w*.80:.1f} {h*.06:.1f} L {w*.90:.1f} {h*.06:.1f} L {w*.96:.1f} {h*.16:.1f}" stroke="{gold}" stroke-width="{max(2,h*.03):.2f}" fill="none"/>'''
 if not compact:body+=crystalline(w,h,light,.72)
 if selected:body+=shard(w/2, h*.12, max(8,h*.08),light)
 return body

def ring_icon(w,h,key,light,gold):
 r=min(w,h)*.34
 return f'<circle cx="{w/2}" cy="{h/2}" r="{r*1.12:.1f}" fill="url(#aura)"/>'+icon_shape(key,w/2,h/2,r,IVORY)+shard(w*.82,h*.22,max(4,r*.08),light)

def compose_svg(id_,family,variant,idx,mode,w,h,component):
 group,number,_,count,_=family
 state,light,gold,highlight,core=tint_and_state(variant,idx,group)
 # En combate, el símbolo y material deben identificar la acción, sin depender solo del color.
 if group=='CTRL' and number=='03' and state not in ('deshabilitado','bloqueado'):
  palette={'golpe':('#f2a18b','#c58c68','#47251f'),
           'proteccion':('#89d7fa','#8ab8de','#103746'),
           'insignia':('#f6e2a3','#ddbe70','#46381a')}
  if component in palette:
   light,gold,core=palette[component]
 selected=state in ('seleccionado','enfocado') or variant in ('activo','aprendido','completado','exito')
 sw=max(1.5,min(w,h)*.005)
 content=''
 if mode in ('button','nav','icon_button','panel','frame','screen','background','toggle','bar','marker'):
  if mode=='bar':
   # Barras automapeables: el relleno es ilustrativo y debe enlazarse a valor runtime en Godot.
   k={'vida_100':1,'vida_75':.75,'vida_50':.5,'vida_25':.25,'xp_50':.5,'xp_100':1}.get(variant,.67)
   y=h*.22; bh=h*.55
   content=f'<rect x="4" y="{y:.1f}" width="{w-8}" height="{bh:.1f}" rx="{bh*.26:.1f}" fill="#071b17" stroke="url(#edge)" stroke-width="3"/>'
   content+=f'<rect x="12" y="{y+8:.1f}" width="{(w-24)*k:.1f}" height="{bh-16:.1f}" rx="{(bh-16)*.23:.1f}" fill="url(#bar)"/>'
   content+=f'<path d="M 15 {y+bh*.35:.1f} Q {w*.49:.1f} {y-bh*.18:.1f} {w*.89*k:.1f} {y+bh*.35:.1f}" fill="none" stroke="#e3ffe1" stroke-opacity=".34" stroke-width="3"/>'
  elif mode=='toggle':
   content=outline(w,h,light,gold,core,selected,compact=True)
   is_on=(idx%2==1 or selected)
   cx=w*.68 if is_on else w*.30
   content+=f'<rect x="{w*.18}" y="{h*.37}" width="{w*.64}" height="{h*.3}" rx="{h*.14}" fill="#071b17" stroke="{light}" stroke-width="2"/><circle cx="{cx:.1f}" cy="{h*.52:.1f}" r="{h*.18:.1f}" fill="{light if is_on else GOLD}" stroke="#daffe4" stroke-width="2"/>'
  elif mode=='marker':
   cx=w/2;cy=h/2
   content=f'<circle cx="{cx}" cy="{cy}" r="{w*.45}" fill="url(#aura)"/>'
   content+=f'<path d="M {cx:.1f} 8 L {w-9:.1f} {cy:.1f} L {cx:.1f} {h-8:.1f} L 8 {cy:.1f} Z" fill="url(#base)" stroke="{gold}" stroke-width="4"/>'
   content+=f'<circle cx="{cx}" cy="{cy}" r="{w*.21}" fill="#0b4938" stroke="{light}" stroke-width="3"/>'
   content+=shard(cx,cy,w*.15,light)
   if variant=='bloqueado':content+=icon_shape('bloqueado',cx,cy,w*.25,IVORY)
  else:
   content=outline(w,h,light,gold,core,selected,compact=mode in ('icon_button',))
   if mode=='button':
    key=component if group=='CTRL' and number=='03' else None
    if key in ('golpe','proteccion','insignia'):
     content+=icon_shape(key,w*.17,h*.50,h*.27,IVORY)
    else:
     content+=shard(w*.14,h/2,h*.18,light)
   elif mode=='nav':
    content+=icon_shape(component,w*.16,h*.48,h*.30,IVORY)
   elif mode=='icon_button':
    which=component
    content+=icon_shape(which,w*.50,h*.50,h*.32,IVORY)
   elif mode in ('panel','screen','frame','background'):
    # Estas piezas son marcos y capas, nunca contienen texto o estadísticas incrustadas.
    if mode=='screen' or mode=='background':
     content+=f'<path d="M {w*.04} {h*.18} L {w*.72} {h*.18} L {w*.78} {h*.22}" fill="none" stroke="{gold}" stroke-opacity=".45" stroke-width="3"/>'
     content+=f'<rect x="{w*.07:.1f}" y="{h*.29:.1f}" width="{w*.62:.1f}" height="{h*.49:.1f}" rx="10" fill="#031914" fill-opacity=".20" stroke="{light}" stroke-opacity=".12" stroke-width="2"/>'
    content+=shard(w*.89,h*.86,max(5,min(w,h)*.06),light)
 elif mode=='icon':
  content=ring_icon(w,h,variant,light,gold)
 elif mode=='ornament':
  content=f'<path d="M 5 {h*.65:.1f} Q {w*.29:.1f} {h*.28:.1f} {w*.49:.1f} {h*.62:.1f} T {w-5} {h*.33:.1f}" fill="none" stroke="{light}" stroke-opacity=".45" stroke-width="5"/>'
  content+=shard(w*.50,h*.49,min(w,h)*.22,light)
  if number=='01':content+=icon_shape('resonancias',w*.2,h*.48,h*.22,IVORY)
 elif mode=='fx':
  # Frame individual listo para storyboard: no prescribe duración ni invoca daño/XP.
  t = (idx%7)/6
  rad=min(w,h)*(.22+t*.23)
  content=f'<ellipse cx="{w/2}" cy="{h/2}" rx="{rad*1.9:.1f}" ry="{rad*1.2:.1f}" fill="url(#aura)"/>'
  for k in range(3):
   r=rad*(.5+k*.39)
   content+=f'<ellipse cx="{w/2}" cy="{h/2}" rx="{r*1.6:.1f}" ry="{r*.75:.1f}" stroke="{light}" stroke-width="{max(1,7-2*k):.1f}" stroke-opacity="{max(.12,.55-k*.15):.2f}" fill="none"/>'
  for k in range(5):
   an=(k*72+idx*29)*math.pi/180
   x=w/2+math.cos(an)*rad*1.3;y=h/2+math.sin(an)*rad*.67
   content+=shard(x,y,8+(idx%3)*4,light)
  if 'quieto' in variant or 'estatico' in variant:content+=icon_shape('completado',w/2,h/2,42,IVORY)
 if state=='deshabilitado':content+=f'<path d="{corner_cut(w,h)}" fill="#0c1f1b" fill-opacity=".47"/>' if mode not in ('icon','fx','bar') else ''
 elif state=='bloqueado':content+=f'<path d="{corner_cut(w,h)}" fill="#202a25" fill-opacity=".36"/>' if mode not in ('icon','fx','bar') else ''
 # SVG sintácticamente autónomo, sin fuentes ni recursos externos; texto vive en Godot.
 out=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" data-component="{component}" data-state="{state}">
 <title>{id_} — {variant}</title><desc>Propuesta 02 Cristal vivo. Elemento gráfico sin reglas ni texto canónico.</desc>
 {defs(light,gold,core)}
 {content}
 </svg>'''
 ET.fromstring(out)
 return out

def create_records():
 records=[]
 for fam in FAMILIES:
  a,b,name,count,variants=fam
  items=variants.split(',')
  if a=='CTRL' and b=='03':items=[f'{act}_{s}' for act in items for s in STATES]
  elif a=='CTRL' and b=='04':items=[f'{act}_{s}' for act in items for s in STATES[:5]]
  elif a=='CTRL' and b=='05':items=[f'{act}_{s}' for act in items for s in STATES[:5]]
  elif a=='CTRL' and b=='07':items=[f'{act}_{s}' for act in items for s in ['apagado','encendido']]
  assert len(items)==count,(a,b,len(items),count)
  for i,item in enumerate(items):
   raw=item
   act,state=(item.rsplit('_',1) if (a=='CTRL' and b in ('03','04','05') and '_' in item) else (item,None))
   # Corrección estado para botones compuestos (sin ambigüedad en nombres).
   if a=='CTRL' and b=='03':act=item.split('_')[0];state=item.split('_')[1]
   if a=='CTRL' and b=='04':state=item.split('_')[-1];act='_'.join(item.split('_')[:-1])
   if a=='CTRL' and b=='05':state=item.split('_')[-1];act='_'.join(item.split('_')[:-1])
   if a=='CTRL' and b=='07':state=item.split('_')[-1];act='_'.join(item.split('_')[:-1])
   mode=mode_for(fam,act,i);w,h=dimensions(mode,act)
   if state in STATES:color_state=state
   else:color_state='seleccionado' if state=='encendido' else ('deshabilitado' if 'deshabilitado' in item else act)
   block= '02-iconos-mapa-combate' if (a=='PANT' and b in [f'{j:02}' for j in range(2,9)]) else '03-equipo-y-progresion' if (a=='PANT' and b in [f'{j:02}' for j in range(11,19)]) else '04-pantallas-y-situaciones' if a=='PANT' else BLOCKS[a]
   slug=slugify(item)
   fn=f'jn-{a.lower()}-{b}-{slug}.svg'
   records.append(dict(id=f'JN-{a}-{b}',familia=name,componente=act,variante=state or act,slug=slug,modo=mode,ancho=w,alto=h,bloque=block,svg=f'{block}/svg/{fn}',png=f'{block}/png/{fn[:-4]}.png',svg_content=compose_svg(f'JN-{a}-{b}',fam,color_state,i,mode,w,h,act)))
 assert len(records)==401
 assert len(set(r['svg'] for r in records))==401
 return records

def font(size,serif=False):
 fonts=('/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf' if serif else '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf','/usr/share/fonts/truetype/liberation2/LiberationSerif-Regular.ttf')
 for p in fonts:
  if Path(p).exists():return ImageFont.truetype(p,size)
 return ImageFont.load_default()

def panel_preview(records,root,bg=None):
 w,h=1600,1030
 img=Image.new('RGBA',(w,h),(4,24,19,255))
 if bg and bg.exists():
  pic=Image.open(bg).convert('RGBA');scale=max(w/pic.width,h/pic.height);pic=pic.resize((int(pic.width*scale),int(pic.height*scale)),Image.Resampling.LANCZOS);pic=pic.crop(((pic.width-w)//2,(pic.height-h)//2,(pic.width+w)//2,(pic.height+h)//2));img.alpha_composite(pic)
 over=Image.new('RGBA',(w,h),(0,5,6,125));img.alpha_composite(over)
 d=ImageDraw.Draw(img)
 d.text((66,37),'KARMANY MONSTA  /  JADE NOCTURNO',font=font(34,True),fill=(242,238,220))
 d.text((66,88),'02  ·  CRISTAL VIVO  /  KIT DE RECURSOS INDEPENDIENTES',font=font(18),fill=(115,250,193))
 d.line((68,125,1530,125),fill=(209,180,111),width=2)
 def asset(key,xy,sz=None):
  a=next((r for r in records if key in r['svg']),None)
  if a is None:return
  fp=root/a['png'];p=Image.open(fp).convert('RGBA')
  if sz:p.thumbnail(sz,Image.Resampling.LANCZOS)
  img.alpha_composite(p,xy)
 def label(s,x,y):d.text((x,y),s,font=font(19),fill=(227,211,166))
 label('BOTONES / ESTADOS',67,157)
 for j,s in enumerate(STATES[:4]):
  label(s.upper(),70+j*360,202)
  asset(f'ctrl-01-{s}',(61+j*360,228),(320,106))
 label('PANELES / MARCOS',67,370)
 asset('base-06-principal', (55,405),(650,415))
 asset('base-03-retrato',(744,408),(283,305))
 asset('base-03-seleccion',(1060,408),(283,305))
 label('BARRAS DE PS / XP',742,722)
 asset('ctrl-08-relleno',(735,757),(650,65))
 asset('fx-04-xp_50',(735,817),(650,65))
 label('ACCIONES Y NAVEGACION',66,728)
 for j,k in enumerate(['ctrl-03-golpe_normal','ctrl-03-proteccion_normal','ctrl-03-insignia_normal']):
  asset(k,(54+j*220,759),(205,80))
 for j,k in enumerate(['ctrl-05-equipo_normal','ctrl-05-libro_normal','ctrl-05-bestiario_normal']):
  asset(k,(60+j*215,861),(202,80))
 label('FUENTES EDITABLES SVG  /  PNG RGBA  /  NO INTEGRADO A GODOT',66,984)
 return img

def make_guide_pages(records,root):
 group_names=['Inicio','Regiones','Mapa','Localizacion','Exploracion','Combate_cabecera','Combate_acciones','Combate_ventanas','Resultados','Vinculacion','Equipo','Selector_equipo','Coleccion','Bestiario','Libro','Perfil_Ezel','Arbol_resonancias','Resonancias_equipadas','Configuracion','Prologo_tutorial','Diagnostico_laboratorio']
 guide_dir=root/'guias';guide_dir.mkdir(parents=True,exist_ok=True)
 for i,name in enumerate(group_names,1):
  matches=[r for r in records if r['id']==f'JN-PANT-{i:02}']
  # También usar piezas reutilizables para señalar ensamblaje modular.
  lines=[f'# Guía {i:02} — {name.replace("_"," ")}', '', 'Propuesta 02 / Cristal vivo. **Estado: propuesta, sin aprobación gráfica individual.**',
  '', f'**Familia del manual:** `JN-PANT-{i:02}`.','', '## Piezas independientes', '', *[f'- `{x["svg"]}` / `{x["png"]}` — {x["componente"]}, {x["ancho"]}×{x["alto"]} px.' for x in matches],
  '', '## Ensamblaje y límites', '', '- La composición de demostración no incorpora cifras, reglas ni contenido nuevos.',
  '- Colocar ilustraciones canónicas y texto vivo en nodos Godot; los SVG/PNG son superficies visuales.',
  '- Respetar Safe Area, jerarquía, 48dp efectivos de área táctil y texto ampliado.',
  '- No estirar esquinas ornamentales: usar paneles NinePatch con márgenes medidos por recurso.',
  '- Registrar aprobación individual antes de trasladar al juego.', '', '## Prueba', '',
  '- Revisar a 1280×720 y 960×540 con texto normal y grande.',
  '- Confirmar selección, foco, bloqueo y contraste sin depender exclusivamente del color.',
  '- Asegurar que los modales no cubren permanentemente los controles necesarios.', '']
  (guide_dir/f'{i:02}-{slugify(name)}.md').write_text('\n'.join(lines),encoding='utf-8')
  # Miniatura libre de datos canónicos.
  canvas=Image.new('RGBA',(960,540),(6,23,19,255));d=ImageDraw.Draw(canvas)
  d.text((28,22),f'JN-PANT-{i:02} / {name.replace("_"," ").upper()}',font=font(22,True),fill=(235,226,197))
  d.line((28,65,926,65),fill=(219,186,112),width=2)
  placements=[(28,92,440,260),(498,93,210,150),(729,91,205,150),(500,279,395,180),(42,398,425,84)]
  for j,r in enumerate(matches[:5]):
   x,y,ww,hh=placements[j];im=Image.open(root/r['png']).convert('RGBA');im.thumbnail((ww,hh),Image.Resampling.LANCZOS);canvas.alpha_composite(im,(x,y))
  d.text((28,508),'MAQUETA DE RECURSOS / SIN ESTADISTICAS CANONICAS',font=font(13),fill=(160,216,184))
  canvas.save(guide_dir/f'{i:02}-{slugify(name)}.png',optimize=True)

def verify(records,root):
 checks=0
 for a in records:
  svg=root/a['svg'];png=root/a['png']
  assert svg.is_file() and ET.parse(svg).getroot().tag.endswith('svg');checks+=1
  with Image.open(png) as im:
   assert im.size==(a['ancho'],a['alto']) and im.mode=='RGBA';checks+=1
 # Comprobar que cada control presenta su icono propio, no un placeholder común.
 for r in records:
  if r['id'] in ('JN-CTRL-03','JN-CTRL-04','JN-CTRL-05'):
   tree=ET.parse(root/r['svg'])
   icons=[g.attrib.get('data-icon') for g in tree.iter() if g.tag.endswith('g') and 'data-icon' in g.attrib]
   assert r['componente'] in icons, (r['svg'],r['componente'],icons)
 assert len(records)==401;checks+=1
 assert len(set(x['svg'] for x in records))==401;checks+=1
 assert len(list((root/'guias').glob('*.md')))==21;checks+=1
 assert checks==805
 return checks

def main():
 parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path,required=True);parser.add_argument('--background',type=Path,default=None);a=parser.parse_args()
 root=a.output;root.mkdir(parents=True,exist_ok=True)
 records=create_records()
 for i,r in enumerate(records):
  sv=root/r['svg'];sv.parent.mkdir(parents=True,exist_ok=True);svg_text=r.pop('svg_content')
  changed=not sv.exists() or sv.read_text(encoding='utf-8')!=svg_text
  if changed: sv.write_text(svg_text,encoding='utf-8')
  png=root/r['png'];png.parent.mkdir(parents=True,exist_ok=True)
  png_invalid=not png.exists() or png.stat().st_size<100
  if not png_invalid:
   with Image.open(png) as existing: png_invalid=existing.size!=(r['ancho'],r['alto']) or existing.mode!='RGBA'
  if changed or png_invalid:
   cairosvg.svg2png(url=str(sv),write_to=str(png),output_width=r['ancho'],output_height=r['alto'])
  if i%100==0:print(f'Generados: {i+1}/401',flush=True)
 root.joinpath('guias').mkdir(exist_ok=True)
 if a.background and a.background.exists():
  b=root/'00-referencias'/'fondo_bruma_cristal_vivo.png';b.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(a.background,b)
 make_guide_pages(records,root)
 panel_preview(records,root,a.background).save(root/'VISTA_PREVIA_MAESTRA.png')
 # catalogo 53 familias basado en el documento maestro, sin inventar aprobación.
 with (root/'catalogo.csv').open('w',newline='',encoding='utf-8') as f:
  csvw=csv.writer(f);csvw.writerow(['id','familia','numero_recursos','estado','carpeta','aprobacion','notas'])
  for fam in FAMILIES:
   a1,b,name,count,_=fam
   rs=[r for r in records if r['id']==f'JN-{a1}-{b}']
   assert len(rs)==count
   csvw.writerow([f'JN-{a1}-{b}',name,count,'propuesta',rs[0]['bloque'],'','No integrado a interfaz ni APK; revisión gráfica pendiente'])
 with (root/'manifiesto.csv').open('w',newline='',encoding='utf-8') as f:
  cols=['id','familia','componente','variante','modo','bloque','svg','png','ancho','alto','sha256_svg','sha256_png','aprobacion']
  cw=csv.DictWriter(f,fieldnames=cols);cw.writeheader()
  for r in records:
   row={k:r[k] for k in cols if k not in ('sha256_svg','sha256_png','aprobacion')}
   row['sha256_svg']=hashlib.sha256((root/r['svg']).read_bytes()).hexdigest()
   row['sha256_png']=hashlib.sha256((root/r['png']).read_bytes()).hexdigest();row['aprobacion']='propuesta'
   cw.writerow(row)
 (root/'README.md').write_text(textwrap.dedent('''\
 # Karmany Monsta Android — Kit Jade Nocturno 02 · Cristal vivo

 **Estado: propuesta elegida como dirección, pero recursos individuales NO aprobados ni incorporados a Godot/APK.**

 Entrega reproducible: **401 SVG originales editables**, **401 PNG RGBA**, **21 guías Markdown con 21 vistas de composición**, referencia de fondo, vista previa, catálogo (53 familias) y manifiesto con SHA-256 por recurso. Se entrega aparte el script generador en `fuente/generate_kit.py`.

 Los archivos se organizan en cuatro bloques del manual: `01-kit-maestro`, `02-iconos-mapa-combate`, `03-equipo-y-progresion` y `04-pantallas-y-situaciones` (los bloques corresponden a la familia, no a una promesa de equivalencia directa con nodos de juego).

 ## Licencia y procedencia

 - Dibujos geométricos SVG: generados procedimentalmente por OpenAI para este proyecto con formas originales (sin paquetes de iconos externos).
 - PNG: rasterizaciones de esos SVG mediante CairoSVG. Son salidas de revisión, no arte de personajes ni criaturas nuevas.
 - Fondo `00-referencias/fondo_bruma_cristal_vivo.png`: referencia de estilo recuperada de la sesión de diseño previa; debe mantenerse como arte propuesto, no como fondo canónico hasta aprobación.
 - No se empaquetan fuentes. Elegir tipografía licenciada apta para redistribución y registrar OFL/licencia antes de integrar; las ilustraciones NO incrustan texto del juego.

 ## Estados

 NORMAL / PULSADO / SELECCIONADO / ENFOCADO / DESHABILITADO / BLOQUEADO donde correspondan. Otras familias tienen variantes semánticas (activos, reserva, completado, disponible, etc.).

 ## Godot 4.x

 1. Mantener todo bajo `docs/diseno/.../propuestas` hasta aprobación formal. No importar automáticamente 401 recursos a la escena.
 2. Preferir SVG para iconos y siluetas cuando el importador funcione; PNG RGBA para revisión y sprites. Importar por grupos.
 3. Usar `StyleBoxTexture` / `NinePatchRect` para marcos, con márgenes calibrados **por recurso**: los cortes son formas con aristas biseladas, no deben estirarse arbitrariamente.
 4. Todo texto, PS, XP, requisitos y porcentajes se coloca mediante nodos en runtime. Una barra SVG con relleno es solo un ejemplo visual: la parte de relleno debe poder escalarse en un nodo separado.
 5. Probar escala horizontal 1280×720 y 960×540, texto grande, áreas seguras Android, contrastes, blancos táctiles ≥48dp reales y accesibilidad de movimiento reducido.
 6. No se asume que el aspecto visual generado verifica calidad Android; crear capturas y test físico antes de integrar.

 ## QA de este paquete

 `805` comprobaciones estructurales: SVG analizable + PNG con tamaño y alfa correctos para cada uno de los 401 recursos (802), unicidad de rutas, total de recursos y 21 guías. Son comprobaciones del **kit**, no pruebas de la aplicación.

 ## Alcance excluido

 No se han alterado el código Godot, la APK, los JSON canónicos, las reglas ni el guardado. La dirección visual escogida por el creador no supone aprobación individual automática de los assets ni autorización para su integración.
 '''),encoding='utf-8')
 script=Path(__file__);source_dir=root/'fuente';source_dir.mkdir(exist_ok=True)
 if script.resolve()!=(source_dir/script.name).resolve():shutil.copy2(script,source_dir/script.name)
 checks=verify(records,root)
 print(f'VALIDACION: {len(records)} SVG + {len(records)} PNG + 21 guías. {checks} comprobaciones superadas.',flush=True)
 return 0

if __name__=='__main__':raise SystemExit(main())
