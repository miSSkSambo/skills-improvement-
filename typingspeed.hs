<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Typing Speed — Animated Web Test</title>
<style>
  :root{
    --bg1:#0b1020; --bg2:#0e1628; --glow:#ffcb2f; --text:#eaf2ff; --muted:#9aa7bf;
    --card:rgba(255,255,255,0.06); --glass:rgba(255,255,255,0.08); --ok:#6ef3a4; --bad:#ff6b6b;
  }
  *{box-sizing:border-box}
  body{margin:0; min-height:100vh; font-family:Inter,system-ui,Segoe UI,Roboto,Arial;
       color:var(--text); background: radial-gradient(1200px 600px at 10% 10%, rgba(255,203,47,0.08), transparent),
                  linear-gradient(160deg,var(--bg1),var(--bg2));
       overflow-x:hidden}

  /* animated background hue */
  .bg-anim{position:fixed; inset:-10vmax; z-index:-1; filter:blur(80px); opacity:0.35; animation:spin 18s linear infinite}
  .bg-anim::before,.bg-anim::after{content:""; position:absolute; border-radius:50%;}
  .bg-anim::before{width:60vmax; height:60vmax; left:0; top:0; background:conic-gradient(from 0deg,#ffd166,#06d6a0,#118ab2,#ef476f,#ffd166)}
  .bg-anim::after{width:50vmax; height:50vmax; right:0; bottom:0; background:conic-gradient(from 180deg,#9b5de5,#f15bb5,#fee440,#00bbf9,#00f5d4,#9b5de5)}
  @keyframes spin{to{transform:rotate(360deg)}}

  .wrap{max-width:1100px; margin: clamp(14px,4vw,32px) auto; padding: 0 14px; display:grid; grid-template-columns: 1.1fr 0.9fr; gap:16px}
  @media (max-width:960px){ .wrap{ grid-template-columns:1fr; } }

  .card{background:linear-gradient(180deg, rgba(255,255,255,0.04), rgba(255,255,255,0.02));
        border:1px solid rgba(255,255,255,0.08); border-radius:16px; box-shadow:0 10px 40px rgba(0,0,0,0.5)}

  header.card{padding:14px 16px; display:flex; align-items:center; justify-content:space-between}
  header h1{font-size:18px; margin:0; letter-spacing:0.3px; color:var(--glow)}
  header .muted{color:var(--muted); font-size:13px}

  .stats{display:flex; gap:10px; flex-wrap:wrap}
  .stat{background:rgba(0,0,0,0.25); border:1px solid rgba(255,255,255,0.08); padding:8px 10px; border-radius:12px; min-width:120px}
  .stat b{display:block; font-size:20px}
  .stat span{font-size:12px; color:var(--muted)}

  .main.card{padding:16px}
  .prompt{position:relative; padding:14px; border-radius:12px; background:rgba(0,0,0,0.28); border:1px solid rgba(255,255,255,0.06);}
  .prompt .text{line-height:1.6; font-size:18px; user-select:none; white-space:pre-wrap}
  .prompt .text span{padding:2px 1px; border-radius:6px}
  .prompt .text span.ok{background:rgba(110,243,164,0.18)}
  .prompt .text span.bad{box-shadow:0 2px 0 var(--bad) inset}
  .caret{position:absolute; width:2px; background:var(--glow); height:1.4em; transform:translateY(4px); animation:blink 1s steps(1) infinite}
  @keyframes blink{50%{opacity:0}}

  textarea.input{width:100%; margin-top:12px; padding:12px 12px 36px; font: 16px/1.6 ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
                 color:#0b1020; background:rgba(255,255,255,0.95); border:1px solid rgba(0,0,0,0.15);
                 border-radius:12px; outline:none}
  .row{display:flex; gap:8px; align-items:center; margin-top:10px; flex-wrap:wrap}
  .row .grow{flex:1}
  button{cursor:pointer; padding:10px 14px; border-radius:10px; border:1px solid rgba(255,255,255,0.12); background:linear-gradient(90deg,var(--glow),#ff9b2f); color:#081024; font-weight:700}
  button.ghost{background:transparent; color:var(--glow)}
  select, .range{padding:10px 12px; border-radius:10px; border:1px solid rgba(255,255,255,0.12); background:rgba(255,255,255,0.04); color:var(--text)}

  .progress{height:10px; border-radius:999px; background:rgba(255,255,255,0.1); overflow:hidden}
  .bar{height:100%; width:0%; background:linear-gradient(90deg,#2dd4bf,#22c55e,#a3e635,#facc15,#fb923c); transition:width .25s ease}

  .panel.card{padding:14px}
  .muted{color:var(--muted)}

  /* Confetti */
  .confetti{position:fixed; inset:0; pointer-events:none; overflow:hidden}
  .confetti i{position:absolute; width:10px; height:18px; background:var(--glow); opacity:.95; transform-origin:center; animation:fall 1400ms linear forwards}
  @keyframes fall{to{transform:translateY(120vh) rotate(720deg); opacity:0}}
</style>
</head>
<body>
  <div class="bg-anim"></div>
  <div class="confetti" id="confetti"></div>

  <header class="card">
    <div>
      <h1>Typing Speed — Animated Web Test</h1>
      <div class="muted">Practice speed & accuracy with real‑time stats and effects</div>
    </div>
    <div class="stats">
      <div class="stat"><b id="wpm">0</b><span>WPM</span></div>
      <div class="stat"><b id="acc">100%</b><span>Accuracy</span></div>
      <div class="stat"><b id="time">00:00</b><span>Time</span></div>
      <div class="stat"><b id="best">0</b><span>Best WPM</span></div>
    </div>
  </header>

  <main class="wrap">
    <section class="main card">
      <div class="prompt">
        <div class="text" id="prompt"></div>
        <div class="caret" id="caret" style="left:8px; top:12px"></div>
      </div>
      <textarea class="input" id="input" rows="6" placeholder="Start typing here to begin the test…"></textarea>
      <div class="row">
        <div class="grow progress"><div class="bar" id="bar"></div></div>
        <button id="new">New Prompt</button>
        <button id="reset" class="ghost">Reset</button>
        <select id="size">
          <option value="short">Short</option>
          <option value="medium">Medium</option>
          <option value="long">Long</option>
        </select>
      </div>
    </section>

    <aside class="panel card">
      <h3 style="margin:6px 0 8px">Tips</h3>
      <ul style="margin:0 0 10px 18px; line-height:1.6">
        <li>Keep shoulders relaxed; let rhythm lead the speed.</li>
        <li>Fix errors quickly but gently—don’t backspace the whole line.</li>
        <li>Short, frequent sessions build consistency better than marathons.</li>
      </ul>
      <p class="muted">Shortcuts: <b>Ctrl/Cmd + N</b> New • <b>Ctrl/Cmd + R</b> Reset</p>
      <p class="muted">Your best WPM is stored locally in your browser.</p>
    </aside>
  </main>

<script>
(function(){
  const SHORT = [
    "Keep your focus steady and your typing light.",
    "Type with rhythm, correct with care.",
    "Small habits become big wins over time.",
    "Clarity comes from steady practice." ];
  const MEDIUM = [
    "Momentum builds from small wins. Each correct word is a pass completed—advance one touch at a time.",
    "Patience turns effort into skill. Notice mistakes without panic and guide your fingers back on course.",
    "Consistency beats intensity. Short, focused sessions improve accuracy and speed with less stress." ];
  const LONG = [
    "The midfield controls the tempo, just like your breath controls your typing speed. Stay relaxed, eyes forward, and let your hands find the rhythm as you move from word to word.",
    "Improvement is mostly quiet and practical. Show up, type with intent, fix small errors, and let time compound your progress without drama." ];

  const $ = id => document.getElementById(id);
  const promptEl = $('prompt'), inputEl = $('input'), caret = $('caret');
  const wpmEl = $('wpm'), accEl = $('acc'), timeEl = $('time'), bestEl = $('best');
  const bar = $('bar'), confettiEl = $('confetti');
  const btnNew = $('new'), btnReset = $('reset'), sizeSel = $('size');

  let prompt = ""; let start = 0; let running = false; let best = +localStorage.getItem('ts.best')||0;
  let timer = null; bestEl.textContent = best;

  function choose(){
    const pool = sizeSel.value==='short'?SHORT: sizeSel.value==='medium'?MEDIUM: LONG;
    return pool[Math.floor(Math.random()*pool.length)];
  }

  function setPrompt(text){
    prompt = text; promptEl.innerHTML = '';
    for (let i=0;i<prompt.length;i++){
      const span = document.createElement('span'); span.textContent = prompt[i];
      promptEl.appendChild(span);
    }
    placeCaret(0);
    bar.style.width = '0%';
  }

  function placeCaret(idx){
    const spans = promptEl.children;
    const target = spans[idx] || spans[spans.length-1] || promptEl;
    const rect = target.getBoundingClientRect();
    const host = promptEl.getBoundingClientRect();
    const x = (rect.left - host.left) + (idx>=spans.length? rect.width : 0);
    const y = rect.top - host.top;
    caret.style.left = Math.max(8, x) + 'px';
    caret.style.top = Math.max(12, y) + 'px';
  }

  function reset(){
    inputEl.value = ''; running = false; start = 0; updateStats();
    for(const s of promptEl.children){ s.classList.remove('ok','bad'); }
    bar.style.width = '0%';
  }

  function newPrompt(){ setPrompt(choose()); reset(); inputEl.focus(); pulse(); }

  function pulse(){
    for(let i=0;i<36;i++) confettiPiece(window.innerWidth/2, window.innerHeight/3, true);
  }
  function celebrate(){
    for(let i=0;i<160;i++) confettiPiece(window.innerWidth/2, window.innerHeight/3);
  }
  function confettiPiece(x,y,soft){
    const el = document.createElement('i');
    el.style.left = (x + (Math.random()*120-60)) + 'px';
    el.style.top = (y + (Math.random()*40-20)) + 'px';
    el.style.background = soft? 'rgba(255,203,47,.5)': randomColor();
    el.style.transform = 'rotate('+ (Math.random()*360)+'deg)';
    el.style.animationDelay = (Math.random()*300)+'ms';
    confettiEl.appendChild(el);
    setTimeout(()=> el.remove(), 1600);
  }
  function randomColor(){
    const palette = ['#ffcb2f','#22d3ee','#34d399','#f472b6','#a78bfa','#fb7185'];
    return palette[Math.floor(Math.random()*palette.length)];
  }

  function onType(){
    if (!running && inputEl.value.length){ running = true; start = performance.now(); }
    const typed = inputEl.value;
    const spans = promptEl.children; const n = Math.min(typed.length, prompt.length);

    for(let i=0;i<spans.length;i++){ spans[i].classList.remove('ok','bad'); }
    let correct = 0;
    for(let i=0;i<n;i++){
      if (typed[i] === prompt[i]){ spans[i].classList.add('ok'); correct++; }
      else { spans[i].classList.add('bad'); }
    }

    const pct = Math.round(100 * n / Math.max(1,prompt.length));
    bar.style.width = pct + '%';
    placeCaret(n);

    updateStats(correct, typed.length);

    if (typed.length >= prompt.length){ finish(); }
  }

  function updateStats(correct=0, typed=0){
    const t = start? Math.max(1, performance.now() - start): 1; // ms
    const minutes = t/60000;
    const wpm = running? Math.round((typed/5)/Math.max(0.01, minutes)) : 0;
    const acc = typed? Math.round(100 * correct / typed) : 100;
    wpmEl.textContent = wpm; accEl.textContent = acc + '%';
    const s = Math.floor(t/1000); const mm = String(Math.floor(s/60)).padStart(2,'0'); const ss = String(s%60).padStart(2,'0');
    timeEl.textContent = mm+':'+ss;
  }

  function finish(){
    running = false;
    const typed = inputEl.value.length;
    const t = Math.max(1, performance.now() - start); const minutes = t/60000;
    const wpm = Math.round((typed/5)/Math.max(0.01, minutes));
    if (wpm > best){ best = wpm; localStorage.setItem('ts.best', best); bestEl.textContent = best; celebrate(); alert('New High Score: '+best+' WPM'); }
    else { pulse(); }
  }

  // Shortcuts
  document.addEventListener('keydown', e=>{
    const mod = e.ctrlKey || e.metaKey;
    if (mod && e.key.toLowerCase()==='n'){ e.preventDefault(); newPrompt(); }
    if (mod && e.key.toLowerCase()==='r'){ e.preventDefault(); reset(); }
  });

  // Events
  inputEl.addEventListener('input', onType);
  btnNew.addEventListener('click', newPrompt);
  btnReset.addEventListener('click', reset);
  sizeSel.addEventListener('change', newPrompt);
  window.addEventListener('resize', ()=> placeCaret(inputEl.value.length));

  // Init
  newPrompt();
})();
</script>
</body>
</html>
