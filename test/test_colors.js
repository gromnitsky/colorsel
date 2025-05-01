import assert from 'assert'
import fs from 'fs'

import chroma from '../node_modules/chroma-js/dist/chroma.cjs'
globalThis.chroma = chroma
import * as main from '../main.js'

suite('text parser', function() {
    test('smoke', function() {
        let r = main.text_parse(`
# comment
1 1 1 foo bar`)
        assert.deepEqual([
            {
                dec: '1, 1, 1',
                hex: '#010101',
                idx: 1,
                name: 'foo bar'
            }
        ], r)
    })

    test('invalid', function() {
        assert.throws( () => main.text_parse(`
1 1 1 foo bar

1 bar
`), /line 4: invalid format/)
    })
})

suite('deltaE', function() {
    test('smoke', function() {
        let list = main.text_parse(fs.readFileSync('CSS_4.txt').toString())
        let filtered_rows = main.find_similar_colors('#f5f5f5', list)
        assert.equal(19, filtered_rows.length)
    })
})
