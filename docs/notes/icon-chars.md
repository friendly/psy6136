# Icon Character Suggestions for index.Rmd

## Setup: Add CSS to `assets/styles.css`

Add this CSS class to your `assets/styles.css` file:

```css
.icon-emoji {
  font-size: 1.5em;
  vertical-align: middle;
  margin-right: 0.2em;
}
```

You can adjust the `font-size` value (e.g., `1.2em`, `1.8em`, `20px`) to get the size you prefer.

---

## 1. Topics (replacing `icons/list.png`)

### Option A: 📋
Clipboard - professional, clear

### Option B: 📝
Memo/notepad - suggests note-taking

### Option C: 📌
Pushpin - highlights important items

### Option D: 🗂️
Card index/file box - organizational

### Option E: ▪️
Small square bullet - minimal, clean


## 2. Lecture notes (replacing `icons/PDF_icon.png`)

### Option A: 📄
Page/document - clean, professional

### Option B: 📃
Page with curl - classic document look

### Option C: 📑
Bookmark tabs - suggests reference material

### Option D: 📕
Closed red book - academic feel


## 3. Readings (replacing `icons/book.png`)

### Option A: 📖
Open book - classic reading symbol

### Option B: 📚
Stack of books - emphasizes multiple sources

### Option C: 📘
Closed blue book - simple book icon


## 4. Construction notice (replacing `icons/construction.png`)

### Option A: 🚧
Construction sign - perfect visual match

### Option B: ⚠️
Warning triangle - alerts to changes


---

## Recommended Combination (with CSS class):

```markdown
#### <span class="icon-emoji">📋</span> Topics:
#### <span class="icon-emoji">📄</span> Lecture notes
#### <span class="icon-emoji">📖</span> Readings:
#### <span class="icon-emoji">🚧</span> Construction notice
```

## All Options with CSS Class:

### Topics:
```markdown
#### <span class="icon-emoji">📋</span> Topics:
#### <span class="icon-emoji">📝</span> Topics:
#### <span class="icon-emoji">📌</span> Topics:
#### <span class="icon-emoji">🗂️</span> Topics:
#### <span class="icon-emoji">▪️</span> Topics:
```

### Lecture notes:
```markdown
#### <span class="icon-emoji">📄</span> Lecture notes
#### <span class="icon-emoji">📃</span> Lecture notes
#### <span class="icon-emoji">📑</span> Lecture notes
#### <span class="icon-emoji">📕</span> Lecture notes
```

### Readings:
```markdown
#### <span class="icon-emoji">📖</span> Readings:
#### <span class="icon-emoji">📚</span> Readings:
#### <span class="icon-emoji">📘</span> Readings:
```

### Construction notice:
```markdown
<span class="icon-emoji">🚧</span> These web pages will be revised...
<span class="icon-emoji">⚠️</span> These web pages will be revised...
```
