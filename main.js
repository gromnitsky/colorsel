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

function mode_list(params) {
    inject_html('list.html', document.querySelector('main'))
}

function mode_about() {
    inject_html('about.html', document.querySelector('main'))
}

function inject_html(file, node) {
    fetch(file).then( r => {
        if (!r.ok) throw new Error(r.status)
        return r.text()
    }).then( text => {
        node.innerHTML = text
    })
}
