(function ($) {
	$.fn.reverse = [].reverse;
}(jQuery));

export const cascade = async (items, direction, speed, callback) => {
	const slide = (el) => {
		return new Promise((resolve, reject) => {
			// perform slide in correct direction
			if (direction == 'up') {
				$(el).slideUp(speed, 'linear');
			} else {
				$(el).slideDown(speed, 'linear');
			}
			// wait duration of slide to resolve
			setTimeout(()=>{
				resolve()
			}, speed)
		})
	}

	let orderedItems = items;
	if (direction == 'up') {
		orderedItems = items.reverse();
	}

	for (let item of orderedItems.get()) {
		await slide(item)
	}

	callback();
};


