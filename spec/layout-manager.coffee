define ['brace'], (Brace) ->

  class Layout1 extends Brace.Layout
  class Layout2 extends Brace.Layout

  manager = new Brace.LayoutManager(new Brace.Navigator(new Brace.Router()))

  describe '#shouldRenderLayout', ->

    it 'is true if no current layout', ->
      expect(manager.shouldRenderLayout(null, new Layout1())).toBeTruthy()

    it 'is true if layout hasn\'t been attempted before', ->
      expect(manager.shouldRenderLayout(new Layout1(), Layout2)).toBeTruthy()

    it 'is true if new layout is different than current layout', ->
      Layout2.prototype.__hashCode = 12345
      expect(manager.shouldRenderLayout(new Layout1(), Layout2)).toBeTruthy()

    it 'is false if current layout is instance of the new layout class', ->
      Layout2.prototype.__hashCode = 5678
      expect(manager.shouldRenderLayout(new Layout2(), Layout2)).toBeFalsy()

  describe '#createUniqueID', ->
    id1 = manager.createUniqueID(new Layout1())
    id2 = manager.createUniqueID(new Layout2())
    expect(id1).not.toBe(id2)

