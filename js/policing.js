$(document).ready (function () { 
	var cnf = {
		prequantifiers: {
			blockgroups: function () {
				var nest = new Nestify (this.data.blockgroups_race, ["id"], this.data.blockgroups_race.columns).data;

				return { 
					nest: nest,
					scale: d3.scaleQuantize ().domain ([0, 100]).range (["a", "b", "c", "d"])
				}
			},
			incidents: function (a) {
				var column = a.column ? a.column : a, comp = a.comp ? a.comp : column;

				if (this.data.incidents) { 
					var x = d3.max (this.data.incidents, function (x) { return x [comp]; })
					var nest = new Nestify (this.data.incidents, ["id"], this.data.incidents.columns);

					return {
						scale: d3.scaleSqrt ().domain ([0, x]).range ([0, 5]),
						nest: nest
					}
				}
			},
			clear: function () { }
		},
		quantifiers: {
			maps: {
				clear: function () { 
					return {"r": 0}
				},
				incidents: function (point, a, prop) {
					var column = a.column ? a.column : a, comp = a.comp ? a.comp : column;
					try {
						if (point && point.properties && prop && prop.nest &&  prop.nest.data [point.properties.id]) { 
							return {
								"r": prop.scale (prop.nest.data [point.properties.id][column].value)
							};
						}

					} catch (e) {
						console.log (arguments);
						console.log (e);
					}
				},
				blockgroups: function (blockgroup, args, prop) {
					var id = blockgroup.properties.id, vars = ["w", "b", "o"], className = "blockgroup ";
					if (prop.nest [id]) { 
						for (var i in vars) { 
							var pctg = parseInt (prop.nest [id] [vars [i]].value ) / parseInt (prop.nest [id].total.value) * 100;
							className += " " + vars [i] + "_" + prop.scale (pctg);  

						}
						className += " p_" + prop.scale ((parseInt (prop.nest [id].b.value) + parseInt (prop.nest [id].o.value)) /  parseInt (prop.nest [id].total.value) * 100);
					}
					return {
						"class": className
					}
				}
			}
		}
	};

	new Ant (cnf);
});
