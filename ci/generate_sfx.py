"""Reproducible original procedural SFX. No recordings or third-party assets."""
from pathlib import Path
import math, random, struct, wave, json
RATE = 22050
ROOT = Path(__file__).resolve().parents[1] / 'assets/sfx'
SPECS = {
 'tap':(.07,1000,'tick'), 'error':(.20,220,'down'),
 'swing':(.22,360,'air'), 'hit':(.20,125,'hit'),
 'zephyr':(.48,520,'air'), 'ushigane':(.48,90,'hit'),
 'kitsunibi':(.48,740,'up'), 'sakuromushi':(.48,330,'pulse'),
 'heal':(.58,440,'chord'), 'shield':(.40,360,'bell'),
 'boost':(.42,520,'up'), 'control':(.42,260,'down'),
 'switch':(.25,320,'air'), 'book_open':(.48,260,'page'),
 'book_pull':(1.10,290,'up'), 'bind_success':(.86,523.25,'chord'),
 'bind_bounce':(.42,330,'bounce'), 'escape':(.45,230,'down'),
 'victory':(.85,392,'chord'), 'defeat':(.65,220,'down'),
 'enter':(.40,330,'bell'), 'item':(.38,660,'bell')}
def render(name, duration, freq, kind):
 rng=random.Random(name);phase=0.;low=0.;samples=[]
 for i in range(round(duration*RATE)):
  t=i/RATE;u=t/duration
  attack=min(1.,t/.012);release=min(1.,(duration-t)/.04)
  env=attack*release*math.exp(-u*(3.5 if kind in ['hit','tick','bell'] else 1.5))
  noise=rng.uniform(-1,1);low=.85*low+.15*noise
  f=freq
  if kind=='up': f*=1+u*2.2
  if kind in ['down','hit']: f*=1-.65*u
  if kind=='bounce': f*=.65+1.6*abs(math.sin(u*math.pi))
  phase+=math.tau*f/RATE
  tone=math.sin(phase)
  if kind=='air': value=low*.95 + tone*.13;env*=math.sin(math.pi*u)**.5
  elif kind=='page': value=(noise-low)*.35+low*.45+tone*.08;env*=.6+.4*math.sin(u*math.pi*5)**2
  elif kind=='hit': value=tone*.7+low*.8+(noise-low)*math.exp(-u*20)*.3
  elif kind=='chord':
   value=0.
   for n,ratio in enumerate([1,1.25,1.5,2]):
    a=t-n*.065
    if a>=0: value+=math.sin(math.tau*freq*ratio*a)*math.exp(-a*3)*.32
  elif kind=='bell': value=tone*.65+math.sin(phase*2.01)*.22*math.exp(-u*4)
  elif kind=='pulse': value=(tone*.65+math.sin(phase*1.5)*.2)*(.65+.35*math.sin(math.tau*t*12))
  else: value=tone*.8+math.sin(phase*2)*.12
  samples.append(value*env)
 peak=max(abs(x) for x in samples); gain=.50/max(peak,.01)
 pcm=b''.join(struct.pack('<h',round(x*gain*32767)) for x in samples)
 with wave.open(str(ROOT/(name+'.wav')),'wb') as w:
  w.setnchannels(1);w.setsampwidth(2);w.setframerate(RATE);w.writeframes(pcm)
 return {'id':name,'duration':duration,'kind':kind,'peak':round(peak*gain,4)}
if __name__=='__main__':
 ROOT.mkdir(exist_ok=True)
 metadata=[render(name,*spec) for name,spec in SPECS.items()]
 (ROOT/'manifest.json').write_text(json.dumps({'origin':'Original deterministic procedural synthesis','generator':'ci/generate_sfx.py','sample_rate':RATE,'clips':metadata},indent=2)+'\n')
 print(f'Generated {len(metadata)} original mono PCM effects')
