

WorkerScript.onMessage = function(msg) {

	var h
	var items = {}

	//Existing Items
	if ( msg.model.count )
	{
		for( var g = 0; g < msg.model.count; g++ )
		{
			h = msg.model.get(g)
			items[h.id] = g
		}
	}

	//Active Items
	if ( msg.items.length )
	{
		for( var i in msg.items )
		{
			h = msg.items[i];
			if ( typeof items[h.id] === 'number' ) {
				msg.model.set(items[h.id], h, items[h.id])
				//msg.model.setProperty(items[h.id], "status", h.downloadstate)
				delete items[h.id]
			} else {
				msg.model.append( h )
			}
		}
		var o = 0
		for( var u in items )
		{
			msg.model.remove(items[u] + o)
			o++
		}
	} else {
		msg.model.clear()
	}
	msg.model.sync()
}

