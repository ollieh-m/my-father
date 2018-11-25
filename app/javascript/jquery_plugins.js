(function ($) {

	$.fn.reverse = [].reverse;

  $.fn.cascade = function(items, direction, speed, callback) {
		slide = (index, el) => {
			if (direction == 'up') {
				$(el).slideUp(speed, 'linear');
			} else {
				$(el).slideDown(speed, 'linear');
			}

			if (index == items.length - 1) {
				callback()
			}
		}

		let orderedItems = items;
		if (direction == 'up') {
			orderedItems = items.reverse();
		}

		orderedItems.each((index, el) => {
			setTimeout(slide, index * speed);
	  })
    
    return this;
  };
 
}(jQuery));

