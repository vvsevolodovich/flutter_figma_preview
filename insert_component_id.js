let selectedFrames = figma.currentPage.selection
let masterComponents = []
 
// Select all master components
selectedFrames.forEach(selectedFrame=>{
  // For selected Frame
  if(selectedFrame.type=="FRAME"){
    let frameComponents = selectedFrame.findAll(n=>n.type==="COMPONENT")
    if(frameComponents.length>0){
      masterComponents=masterComponents.concat(frameComponents)
    }
  }
 
  // For selected Component
  if(selectedFrame.type=="COMPONENT"){
    masterComponents = masterComponents.concat(selectedFrame)
  }
})
  
// Working with component description
masterComponents.forEach(component => {
  let componentDescription = component.description
 
  // Add Component ID
  addComponentID(component)
​
  figma.notify("Component Description is updated")
})
 
function addComponentID(component){
  // Check if we don't have component ID already 
  if(component.description.search("Design: ")==-1){
    // Add Component description
    component.description=component.description.concat("\nDesign: "+component.id)
  }
}
​