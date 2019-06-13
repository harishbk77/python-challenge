function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
    // Use d3 to select the panel with id of `#sample-metadata`
    var defaultURL = "/metadata/" + sample;
    //alert(defaultURL)
    d3.json(defaultURL).then(function(data) {
      var mydata = [data];
     
      console.log(mydata);
      // document.getElementById('sample-metadata').innerHTML = JSON.stringify(mydata); 
      var txt = "";
      txt += '<table style:"border-spacing: 5px;">';
//AGE: 24, BBTYPE: "I", ETHNICITY: "Caucasian", GENDER: "F", LOCATION: "Beaufort/NC", …}


      for (x in mydata) {
        txt += "<tr><td>AGE: " + mydata[x].AGE + "</td></tr><tr><td>BBTYPE: " + mydata[x].BBTYPE + "</td></tr><tr><td>ETHNICITY: " + mydata[x].ETHNICITY + "</td></tr><tr><td>GENDER: " + mydata[x].GENDER + "</td></tr><tr><td>LOCATION: " + mydata[x].LOCATION + "</td></tr>";
      }
      txt += "</table>" ;
      console.log(txt);
      document.getElementById('sample-metadata').innerHTML = txt;
      });


    // Use `.html("") to clear any existing metadata

    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.

    // BONUS: Build the Gauge Chart
    // buildGauge(data.WFREQ);
}

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots
  var defaultURL = "/samples/" + sample;
  //alert(defaultURL);
  d3.json(defaultURL).then(function(data) {
    var mydata = [data];
    var otu_labels = mydata[0].otu_labels.slice(1,10);
    var otu_ids = mydata[0].otu_ids.slice(1,10);
    var samples = mydata[0].sample_values.slice(1,10);
    
    //console.log(samples)
    //console.log(otu_labels)

    // @TODO: Build a Bubble Chart using the sample data
    var myBubble = document.getElementById('bubble');
    var xvals = mydata[0].otu_ids.slice(1,10);
    var yvals = mydata[0].sample_values.slice(1,10);
    var markersize = mydata[0].sample_values.slice(1,10);
    var colors = mydata[0].otu_ids.slice(1,10);
    var textvalues = mydata[0].otu_labels.slice(1,10);

    var trace = "";
    trace = [{
      x: xvals,
      y: yvals,
      marker: {
      color: colors,
      size: markersize,
      }
    }];
    Plotly.plot(myBubble, trace);

    // @TODO: Build a Pie Chart
    var myPlot = document.getElementById('pie');

    var data = [{
      values: samples,
      type: 'pie',
      hoverinfo: otu_labels,
      labels: otu_ids
     }];
  
    Plotly.plot(myPlot, data);
  });

    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  //alert("Here " + newSample);

  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
