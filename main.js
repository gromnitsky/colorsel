/* global chroma */

export function router(location_search) {
    let params = new URLSearchParams(location_search || window.location.search)
    if (!params.get('m')) params.set('m', 'list')
    let modes = {
        'list': mode_list,
        'about': mode_about,
    }
    document.querySelector('main').innerHTML = '⏳'
    modes[params.get('m')](params)

    // select the current menu item
    document.querySelectorAll('a.menuitem').forEach( a => {
        let t = new URLSearchParams(a.getAttribute('href'))
        let op = t.get('m') === params.get('m') ? 'add' : 'remove'
        a.classList[op]('selected')
    })
}

async function mode_about() {
    let html = await fetch_text('about.html')
    let main = document.querySelector('main')
    inject_html(html, main)
}

/* eslint dot-notation: "off" -- in `form` object it's idiomaic */
async function mode_list(params) {
    let html = await fetch_text('list.html')
    let main = document.querySelector('main')
    inject_html(html, main)

    let form = main.querySelector('form')
    let table = main.querySelector('#table')

    let rows = async () => {
        return text_parse(await fetch_text(`${form["menuitem"].value}.txt`))
    }

    form.onchange = async evt => { // reset list, but preserve filter
        if (evt.target.name !== 'menuitem') return
        update_url('list', form)
        full_rows = await rows()
        let filtered_rows = filter_rows(form["filter"].value, full_rows)
        render(filtered_rows, table)
    }

    form.onsubmit = evt => {    // do filtering only
        evt.preventDefault()
        update_url('list', form)

        let filtered_rows = filter_rows(form["filter"].value, full_rows)
        render(filtered_rows, table)
    }

    form["menuitem"].value = params.get('menuitem')
    if (!form["menuitem"].value) form["menuitem"].value = "CSS_4"
    form["filter"].value = params.get('filter')

    let full_rows = await rows()
    let filtered_rows = filter_rows(form["filter"].value, full_rows)
    render(filtered_rows, table)
}

function render(rows, container) {
    let thead = ['<thead>', '<tr>', '<th>#</th>', '<th>Color</th>',
                 '<th>Dec</th>', '<th>Hex</th>', '<th>Name</th>',
                 '</tr>', '</thead>']
    let html = ['<table>'].concat(thead, '<tbody>', rows.map(row2html),
                                  '</tbody>', '</table>').join``
    inject_html(html, container)

    container.querySelector('table').onclick = evt => {
        if (!evt.target.classList.contains('copyable')) return
        navigator.clipboard.writeText(evt.target.innerText)
    }
}

function filter_rows(pattern, rows) {
    pattern = pattern.trim().toLowerCase()
    if (!pattern) return rows
    return rows.filter( v => {
        return (v.dec + v.hex + v.name).toLowerCase().indexOf(pattern) !== -1
    })
}

export function text_parse(str) {
    let index = 1
    return str.split("\n").map( line => {
        line = line.trim()
        return line.startsWith('#') ? '' : line
    }).map( (line, idx) => {
        if (!line) return ''
        let match = line.match(/^([0-9]+\s+[0-9]+\s+[0-9]+)\s+(.+)/)
        if (!match) throw new Error(`line ${idx+1}: invalid format`)
        let rgb = match[1].split(/\s+/)
        let color = chroma(rgb)
        return {idx: index++, dec: rgb.join`, `, hex: color.hex(), name: match[2]}
    }).filter(Boolean)
}

function row2html(row) {
    return [
        '<tr>',
        `<td>${row.idx}</td>`,
        `<td><div style="background: ${row.hex}"></div></td>`,
        `<td class="copyable">${row.dec}</td>`,
        `<td class="copyable">${row.hex}</td>`,
        `<td class="copyable">${escape_html(row.name)}</td>`,
        '</tr>'
    ].join``
}

function escape_html(s) {
    let div = document.createElement('div')
    div.textContent = s
    return div.innerHTML
}

function update_url(m, form) {
    let fd = new FormData(form)
    let params = new URLSearchParams(fd)
    params.set('m', m)
    window.history.replaceState(null, '', '?' + params.toString())
}

function fetch_text(file) {
    return fetch(file).then( r => {
        if (!r.ok) throw new Error(r.status)
        return r.text()
    })
}

function inject_html(html, parent) {
    let div = document.createElement('div')
    div.innerHTML = html
    parent.innerHTML = ''
    return parent.appendChild(div)
}
