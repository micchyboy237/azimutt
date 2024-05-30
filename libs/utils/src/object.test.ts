import {describe, expect, test} from "@jest/globals";
import {
    equalDeep,
    filterValues,
    mapValues,
    mapValuesAsync,
    minusFieldsDeep,
    removeEmpty,
    removeFieldsDeep,
    removeUndefined
} from "./object";

describe('object', () => {
    test('equalDeep', () => {
        expect(equalDeep(1, 1)).toEqual(true)
        expect(equalDeep(1, 2)).toEqual(false)
        expect(equalDeep('a', 'a')).toEqual(true)
        expect(equalDeep('a', 'b')).toEqual(false)
        expect(equalDeep(true, true)).toEqual(true)
        expect(equalDeep(true, false)).toEqual(false)
        expect(equalDeep([1, 2], [1, 2])).toEqual(true)
        expect(equalDeep([1, 2], [1, 3])).toEqual(false)
        expect(equalDeep([1, 2], [1, 2, 3])).toEqual(false)
        expect(equalDeep({id: 1}, {id: 1})).toEqual(true)
        expect(equalDeep({id: 1}, {id: 2})).toEqual(false)
        expect(equalDeep({id: 1}, {id: 1, name: 'N'})).toEqual(false)
    })
    test('filterValues', () => {
        expect(filterValues({a: 1, b: 2, c: 3, d: 4}, (v: number) => v % 2 === 0)).toEqual({b: 2, d: 4})
    })
    test('mapValues', () => {
        expect(mapValues({a: 'luc', b: 'jean'}, v => v.length)).toEqual({a: 3, b: 4})
    })
    test('mapValuesAsync', async () => {
        expect(await mapValuesAsync({a: 'luc', b: 'jean'}, async v => v.length)).toEqual({a: 3, b: 4})
    })
    test('minusFieldsDeep', () => {
        expect(minusFieldsDeep(1, 1)).toEqual(undefined)
        expect(minusFieldsDeep(1, 2)).toEqual(1)
        expect(minusFieldsDeep('id', 'id')).toEqual(undefined)
        expect(minusFieldsDeep('id', 'name')).toEqual('id')
        expect(minusFieldsDeep(true, true)).toEqual(undefined)
        expect(minusFieldsDeep(true, false)).toEqual(true)
        expect(minusFieldsDeep(null, null)).toEqual(undefined)
        expect(minusFieldsDeep(null, 1)).toEqual(null)
        expect(minusFieldsDeep([1, 2, 3], [1, 2, 3])).toEqual(undefined)
        expect(minusFieldsDeep([1, 2, 3], [1, 4, 3])).toEqual([undefined, 2, undefined])
        expect(minusFieldsDeep({id: 1, name: 'id'}, {id: 1, name: 'id'})).toEqual(undefined)
        expect(minusFieldsDeep({id: 1, name: 'id'}, {id: 1, name: 'name'})).toEqual({name: 'id'})
        expect(minusFieldsDeep(
            {name: 'users', attrs: [{name: 'id', type: 'uuid', nullable: true}, {name: 'name'}]},
            {name: 'users', attrs: [{name: 'id', type: 'uuid'}, {name: 'name'}]}
        )).toEqual({attrs: [{nullable: true}, undefined]})
    })
    test('removeEmpty', () => {
        expect(removeEmpty({a: 'luc', b: '', c: undefined, d: null, e: []})).toEqual({a: 'luc'})
    })
    test('removeFieldsDeep', () => {
        expect(removeFieldsDeep({
            id: 1,
            name: 'test',
            children: [
                {id: 2, name: 'child'}
            ]
        }, ['id'])).toEqual({name: 'test', children: [{name: 'child'}]})
    })
    test('removeUndefined', () => {
        expect(removeUndefined({a: 'luc', b: '', c: undefined, d: null, e: []})).toEqual({a: 'luc', b: '', d: null, e: []})
    })
})
