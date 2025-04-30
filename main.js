router()

function router(location_search) {
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

async function mode_list(params) {
    let html = await fetch_text('list.html')
    let main = document.querySelector('main')
    main.innerHTML = ''
    mkchild(html, main)

    main.querySelector('form').onsubmit = evt => {
        evt.preventDefault()
        console.log(1)
    }
}

async function mode_about() {
    let html = await fetch_text('about.html')
    let main = document.querySelector('main')
    main.innerHTML = ''
    mkchild(html, main)
}

function fetch_text(file) {
    return fetch(file).then( r => {
        if (!r.ok) throw new Error(r.status)
        return r.text()
    })
}

function mkchild(html, parent) {
    let div = document.createElement('div')
    div.innerHTML = html
    return parent.appendChild(div)
}
