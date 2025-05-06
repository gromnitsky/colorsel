/* global chroma */

export function router(location_search) {
    let params = new URLSearchParams(location_search || window.location.search)
    if (!params.get('m')) params.set('m', 'list')
    let modes = {
        'list': mode_list,
        'about': mode_about,
    }
    document.querySelector('main').innerHTML = '⏳'
    my_viewtransition( () => modes[params.get('m')](params))

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
    form.style.viewTransitionName = 'none'
    let file_dialog = main.querySelector('#file_dialog')

    let rows = async () => {
        let url = form["menuitem"].value
        if (url === "userfile") {
            if (!file_dialog.files.length) return []
            url = URL.createObjectURL(file_dialog.files[0])
        } else {
            url += '.txt'
        }
        return text_parse(await fetch_text(url))
    }

    form.onchange = async evt => { // reset list, but preserve filter
        if ( !(evt.target.name === 'menuitem'
               || evt.target.id === 'file_dialog')) return
        update_url('list', form)
        try {
            full_rows = await rows()
        } catch (e) {
            alert(e)
            full_rows = []
        }
        let filtered_rows = filter_rows(form, full_rows)
        render(filtered_rows, main)
    }

    file_dialog.onchange = () => { // firefox/wekbit
        form["menuitem"].value = 'userfile'
    }

    form.onsubmit = evt => {    // do filtering only
        evt.preventDefault()
        update_url('list', form)

        let filtered_rows = filter_rows(form, full_rows)
        render(filtered_rows, main)
    }

    main.querySelector('table').onclick = evt => {
        if (!evt.target.classList.contains('copyable')) return
        navigator.clipboard.writeText(evt.target.innerText)
    }

    // initialise form elements with values from a URL
    form["menuitem"].value = params.get('menuitem')
    if (!form["menuitem"].value) form["menuitem"].value = "CSS_4"
    form["filter-type"].value = params.get('filter-type')
    if (!form["filter-type"].value) form["filter-type"].value = "substring"
    form["filter"].value = params.get('filter')
    form["color"].value = params.get('color')

    let full_rows = await rows()
    let filtered_rows = filter_rows(form, full_rows)
    render(filtered_rows, main)
}

function render(rows, main) {
    my_viewtransition( () => {
        main.querySelector('tbody').innerHTML = rows.map(row2html).join``
        main.querySelector('#stat').innerHTML = `Rows: ${rows.length}`
    })
}

function filter_rows(form, rows) {
    if ("substring" === form["filter-type"].value) {
        let s = form["filter"].value.trim().toLowerCase()
        if (!s) return rows
        return rows.filter( v => {
            return (v.rgb + v.hex + v.name).toLowerCase().indexOf(s) !== -1
        })
    }
    return find_similar_colors(form["color"].value, rows)
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
        return {idx: index++, rgb: rgb.join`, `, hex: color.hex(), name: match[2]}
    }).filter(Boolean)
}

export function find_similar_colors(hex, list) {
    return list.map( v => {
        return Object.assign({deltaE: chroma.deltaE(hex, v.hex)}, v)
    }).filter( v => v.deltaE <= 10).sort( (a, b) => a.deltaE - b.deltaE)
}

function row2html(row) {
    return [
        '<tr>',
        `<td>${row.idx}</td>`,
        `<td><div style="background: ${row.hex}"></div></td>`,
        `<td class="copyable">${row.rgb}</td>`,
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

function my_viewtransition(fn) {
    if (document.startViewTransition) {
        document.startViewTransition( () => fn())
    } else {
        fn()
    }
}
