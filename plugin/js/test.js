/**
 * app.VisitSwitcher dijit component
 */
dojo.provide("app.views.VisitSwitcher");
dojo.require("dijit._Templated");
dojo.require("dijit._Widget");
dojo.require("dijit.TooltipDialog");
dojo.require("app.utils");

dojo.declare("app.views.VisitSwitcher", [dijit.TooltipDialog, app.utils.dateFunctionsMixin], {
	baseClass: "appVisitSwitcher",
	closable: true,
	//hold visits collection
	visits: null,
	postCreate: function() {
		this.inherited(arguments);
		this.visits = {};
		dojo.connect(this.containerNode, 'onclick', this, 'onclick');
		dojo.subscribe("setCurrentPatient", this, 'onPatientChange');
	},
	_tableHead: '<table cellspacing="0" cellpadding="0" class="medappGrid"><thead><tr class="medappGridHeader"><th class="medappGridCell" nowrap="nowrap">Admitted at</th><th class="medappGridCell" nowrap="nowrap">Discharged at</th></tr></thead>',
	_tdStart: '<td class="medappGridCell" nowrap="nowrap" style="white-space:nowrap;">',
	load: function(patientId) {
		url = ['/patients/', patientId, '/visits.js'].join('');
		this.displayLoading();
		dojo.xhrGet({
			url: url,
			handleAs: "json",
			load: dojo.hitch(this, 'setVisits'),
			error: function(err) {
				this.containerNode.innerHTML = 'Load error occurred: ' + err;
			}
		});
	},
	displayLoading: function() {
		this.containerNode.innerHTML = 'Loading...';
	},
	setVisits: function(visits) {
		this.containerNode.innerHTML = 'ok';
		var html = [this._tableHead];
		//clear visits
		this.visits = {};
		dojo.forEach(visits, function(item, index) {
			//fill visits hash
			this.visits[item.id] = item;
			//console.log('Current visit', this.current_visit_id);
			//console.log('Loaded visit', item.id);
			var isCurrent = this.current_visit_id == item.id;
			//console.log('is current', isCurrent);
			if (isCurrent) {
				dojo.publish('setCurrentVisit', [item]);
			}

			html.push('<tr class="medappGridRow ' + ((index % 2 == 1) ? 'medappGridRowOdd ': ' ') + (isCurrent ? 'medappGridSelectedRow': '') + '" visitId="' + item.id + '">');
			html.push(this._tdStart, this._parseAndFormatDate(item.admit_date_time), '</td>');
			html.push(this._tdStart, this._parseAndFormatDate(item.discharge_date_time), '</td>');
			html.push('</tr>');
		},
		this);
		html.push('</table>');
		this.containerNode.innerHTML = html.join('');
	},
	onclick: function(event) {
		if (event.target.tagName == 'TD') {
			dojo.query('.medappGridSelectedRow', this.containerNode).removeClass('medappGridSelectedRow');
			var tr = event.target.parentNode;
			dojo.addClass(tr, 'medappGridSelectedRow');
			var visitId = dojo.attr(tr, 'visitId');
			var visit = this.visits[visitId];
			if (visit) {
				dojo.publish('setCurrentVisit', [visit]);
				//console.log('setCurrentVisit',visit);
			}
			//close tt
			this.onCancel();
		}
	},
	onPatientChange: function(patient) {
		//console.log(patient);
		if (patient && patient.id) {
			this.current_visit_id = patient.visit_id;
			this.load(patient.id);
		}
	}
});
