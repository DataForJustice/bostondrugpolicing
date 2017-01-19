$(document).ready (function () { 
	var cnf = {
		prequantifiers: {
			blockgroups: function () {
				var nest = new Nestify (this.data.blockgroups_race, ["id"], this.data.blockgroups_race.columns).data;

				return { 
					nest: nest,
					scale: d3.scaleQuantize ().domain ([0, 100]).range (["a", "b", "c", "d"])
				}
			}
		},
		quantifiers: {
			maps: {
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
