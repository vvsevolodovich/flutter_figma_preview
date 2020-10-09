  

letselectedFrames=figma.currentPage.selection
letmasterComponents=[]
 
// Select all master components
selectedFrames.forEach(selectedFrame=>{
 
// For selected Frame
if(selectedFrame.type=="FRAME"){
letframeComponents=selectedFrame.findAll(n=>n.type==="COMPONENT")
if(frameComponents.length>0){
masterComponents=masterComponents.concat(frameComponents)
}
}
 
// For selected Component
if(selectedFrame.type=="COMPONENT"){
masterComponents=masterComponents.concat(selectedFrame)
}
})
 
// Working with component description
masterComponents.forEach(component=>{
letcomponentDescription=component.description
 
// Add Component ID
addComponentID(component)
})
 
functionaddComponentID(component){
letresult=null

// Check if we don't have component ID already 
if(component.description.search("Design: ")==-1){
print("Yes")

// Add Component description
component.description=component.description.concat("Design: "+component.id+"\n")
}
returnresult


