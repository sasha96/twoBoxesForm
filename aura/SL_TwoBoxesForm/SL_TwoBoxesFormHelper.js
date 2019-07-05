({
    /*
        sort elements
    */
    sortByName: function (listElems) {
        var result = listElems.sort(function (a, b) {
            var x = a.Name.toLowerCase();
            var y = b.Name.toLowerCase();
            if (x < y) {
                return -1;
            }
            if (x > y) {
                return 1;
            }
            return 0;
        });
        return result;
    },

})