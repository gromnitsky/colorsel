import assert from 'assert'

import chroma from '../node_modules/chroma-js/dist/chroma.cjs'
globalThis.chroma = chroma
import {text_parse} from '../main.js'

suite('text parser', function() {
    setup(function() {
    })

    test('smoke', function() {
        let r = text_parse(`
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
        assert.throws( () => text_parse(`
1 1 1 foo bar

1 bar
`), /line 4: invalid format/)
    })
})
