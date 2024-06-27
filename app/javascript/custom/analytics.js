console.log("hello")
document.addEventListener('page:change', function() {
    console.log("hello")
    if (window._gaq != null) {
        return _gaq.push(['_trackPageview']);
    } else if (window.pageTracker != null) {
        return pageTracker._trackPageview();
    }
});
