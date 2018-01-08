var tabAdjustChildHeight = {};
tabAdjustChildHeight.tabId = null;
tabAdjustChildHeight.ie6TopContainer = {};

function initTabChildAdjustment(tabId){
    tabAdjustChildHeight.tabId = tabId;
    if ( dojo.isIE == 6 ) {
        var d = dijit.byId(tabAdjustChildHeight.tabId);
        // IE6 doesn't work properly with doLayout="false"
        dojo.attr(d,'doLayout','true'); // reset for default one
        d.domNode.style.height = '1px'; // hack
        dojo.query('.dijitContentPane',dojo.byId(tabAdjustChildHeight.tabId))
            .map(function(item){
                var h = item.style.height ? item.style.height : item.style.minHeight;
                item.style.height = h;
        });
        if ( tabAdjustChildHeight.ie6TopContainer.id ) {
            var top = tabAdjustChildHeight.ie6TopContainer;
            var s = dijit.byId(top.id);
            // IE6 doesn't work properly with doLayout="false"
            dojo.attr(s,'doLayout','true'); // reset for default one
            s.domNode.style.height = top.height+'px';
         }
    }
    else {
        // in order this idea does work - the height must be 'auto'
        dojo.query('.dijitContentPane',dojo.byId(tabAdjustChildHeight.tabId))
        .style({'height':'auto'});
    }
    adjustTabChild();
    dojo.subscribe(tabAdjustChildHeight.tabId+'-selectChild',function(child){
        adjustTabChild();
    });
    dojo.subscribe(tabAdjustChildHeight.tabId+'_adjust-Child-Height',function(child){
        adjustTabChild();
    });
}
function adjustTabChild(){
    var mainTab = dijit.byId(tabAdjustChildHeight.tabId);
    var cs = mainTab.domNode.scrollHeight;
    var ch = mainTab.domNode.clientHeight;
    var curscroll = mainTab.selectedChildWidget.domNode.scrollHeight;
    var curheight = mainTab.selectedChildWidget.domNode.clientHeight;
    if ( ch < cs ) {
        if ( curheight < curscroll ) { // this 'if' only for IE6
            //console.log('1 else if works');
            var tl = dojo.marginBox(
                dojo.byId(tabAdjustChildHeight.tabId+'_tablist'))['h']+2;
            var c = tl+curscroll;
            mainTab.domNode.style.height = c+'px';
            var pt = dojo._getPadBorderExtents(
                mainTab.selectedChildWidget.domNode)['t'];
            mainTab.selectedChildWidget.domNode.style.height = curscroll-pt+'px';
        } else {
            var tablist = dojo.marginBox(
                dojo.byId(tabAdjustChildHeight.tabId+'_tablist'))['h']+2;
            mainTab.domNode.style.height = curheight+tablist+'px';
            //console.log('resize works');
        }
    }
    else if ( curheight < curscroll ) { // this 'else if' only for IE6
        //console.log('2 else if works');
        var m = dojo._getMarginExtents(mainTab.domNode)['h'];
        var p = dojo._getPadBorderExtents(mainTab.domNode)['h'];
        var tablist = dojo.marginBox(
            dojo.byId(tabAdjustChildHeight.tabId+'_tablist'))['h']+2;
        var p1 = dojo._getPadBorderExtents(
            mainTab.selectedChildWidget.domNode);
        var p2 = p1.h - p1.t;
        var c = m+p+tablist+curscroll+p2;
        mainTab.resize({h:c});
        mainTab.layout();
        var s = curscroll-p1.t;
        mainTab.selectedChildWidget.domNode.style.height = s+'px';
    }
    else {
        var tablist = dojo.marginBox(
            dojo.byId(tabAdjustChildHeight.tabId+'_tablist'))['h']+2;
        mainTab.domNode.style.height = curheight+tablist+'px';
        //console.log('else works');
    }
}
function ie6TopContainer(top){
    tabAdjustChildHeight.ie6TopContainer.id = top.id || '';
    tabAdjustChildHeight.ie6TopContainer.height = parseInt(top.height) || 400;
}
