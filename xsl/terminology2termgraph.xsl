<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:doctales="http://doctales.github.io"
    exclude-result-prefixes="xs doctales" version="2.0">
    
    <!-- Import the DITA2XHTML stylesheet to use its templates -->
    <xsl:import href="plugin:org.dita.xhtml:xsl/dita2xhtml.xsl"/>
    
    <xsl:output method="html"
        encoding="UTF-8"
        indent="yes"
        doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
    <!-- The parameter $newline defines a line break. -->
    <xsl:variable name="newline">
        <xsl:text>
        </xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><!----></meta>
                <title>Terminology Net</title>
                <xsl:value-of select="$newline"/>
                <style type="text/css">
                    body {
                        font: 10pt arial;
                    }
                    #mynetwork {
                        width: 100%;
                        height: 1000px;
                        border: 1px solid lightgray;
                    }
                </style>
                <xsl:value-of select="$newline"/>
                <!-- DEFAULT -->
                <!--
                    <script type="text/javascript" src="./Network _ Shapes_files/vis.js"></script>
                    <link href="./Network _ Shapes_files/vis.css" rel="stylesheet" type="text/css"/>
                -->
                
                <!-- CDN Normal -->
                <!--
                    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.17.0/vis.js"></script>
                    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.17.0/vis.css"/>
                -->
                
                <!-- CDN Minimized -->
                <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.17.0/vis.min.js"><!----></script>
                <xsl:value-of select="$newline"/>
                <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.17.0/vis.min.css"><!----></link>
                
                <!--
                    TODO: http://visjs.org/docs/data/dataset.html
                -->  
            
                <script type="text/javascript">
                    var nodes = null;
                    var edges = null;
                    var network = null;
                    function draw() {
                        nodes = [<xsl:apply-templates mode="nodes"/>];
                        edges = [
                            {id: 'edge_1', from: 'truck', to: 'car', style: 'arrow', label: 'is related to'},
                            {id: 'edge_2', from: 'wheel', to: 'car', style: 'arrow', label: 'is part of'},
                            {id: 'edge_3', from: 'car', to: 2, style: 'arrow-center'}
                        ];
                        var mainId = 5;
                        // create a network
                        var container = document.getElementById('mynetwork');
                        var data = {
                            nodes: nodes,
                            edges: edges
                        };
                        // specify options
                        var options = {
                            stabilize: false,
                            interaction: {
                                hover: true
                            },
                            edges: {
                                width: 2,
                                style: 'arrow',
                                color: 'gray'
                            },
                            physics: {
                                barnesHut: {
                                    // this is the correct way to set the length of the springs
                                    springLength:200
                                }
                            },
                            groups: {
                                term: {
                                    radius: 1500,
                                    color: {
                                        border: '#004455',
                                        background: '#5fbcd3',
                                        fontColor: '#ffffff',
                                        hover: {
                                            background: '#a5ecfd',
                                            border: '#004455',
                                            fontColor: '#ffffff'
                                        },
                                        highlight: {
                                            border: '#4d4d4d',
                                            background: '#4d4d4d',
                                            fontColor: '#ffffff'
                                        }
                                    },
                                    fontSize: 18,
                                    fontFace: 'arial',
                                    shape: 'box',
                                }
                            }
                        };
                        network = new vis.Network(container, data, options);
                        network.on( 'click', function(params) {
                            if (!(params.nodes == 0)) {
                                alert('clicked node ' + params.nodes + ', ' + params.edges);
                            }
                        });
                    }
                </script>
            <!--<script type="text/javascript">
                if (document.addEventListener) { // IE >= 9; other browsers
                document.addEventListener('contextmenu', function(e) {
                alert("You've tried to open context menu"); //here you draw your own menu
                e.preventDefault();
                }, false);
                } else { // IE < 9
                     document.attachEvent('oncontextmenu', function() {
                         alert("You've tried to open context menu");
                         window.event.returnValue = false;
                     });
                 }
               </script>-->
            </head>
            <body onload="draw()">
                <div id="mynetwork">
                    <div class="vis network-frame" 
                        style="position: relative; overflow: hidden; user-select: none; touch-action: pan-y; -webkit-user-drag: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); width: 100%; height: 100%;">
                        <canvas width="1894" height="600" style="position: relative; user-select: none; touch-action: pan-y; -webkit-user-drag: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); width: 100%; height: 100%;"/>
                    </div>
                </div>
                <div id="info"/>
            </body>
        </html>
    </xsl:template>

    <!-- termref -->
    <!--{id: 'car', label: 'car_label', shape: 'box', group: 'term'},-->
    <xsl:template match="*[contains(@class, ' termmap/termref ')]" mode="nodes">
        <xsl:text>{id: '</xsl:text>
        <xsl:value-of select="@keys"/>
        <xsl:text>', label: '</xsl:text>
        <xsl:value-of select="descendant::*[contains(@class, ' topic/navtitle ')][1]"/>
        <xsl:text>', shape: 'box', group: 'term'}</xsl:text>
        <xsl:choose>
            <xsl:when test="following-sibling::*[contains(@class, ' termmap/termref ')]">
                <xsl:text>,</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Fall Through Templates -->
    <xsl:template match="*[contains(@class, ' topic/navtitle ')]" mode="nodes"/>

    <!--<!-\- Empty template to avoid the processing of the termentry topics -\->
    <xsl:template match="*[contains(@class, ' termentry/termentry ')]"/>

    
    <!-\- Remove HTML clutter -\->
    <xsl:template name="chapter-setup">
        <xsl:call-template name="chapterBody"/>
    </xsl:template>
    
    <xsl:template name="chapterBody">
        <xsl:apply-templates select="." mode="chapterBody"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*" mode="chapterBody"/>-->
    
</xsl:stylesheet>
