/// Declarative description of the lead funnel to keep UI and services aligned.
enum LeadFlowStage {
  requestContact,
  createLead,
  chatBot,
  shareContacts,
  closeLead,
}

class LeadFlow {
  const LeadFlow(this.currentStage);

  final LeadFlowStage currentStage;

  LeadFlow proceed() {
    final nextIndex = currentStage.index + 1;
    final stages = LeadFlowStage.values;
    return LeadFlow(stages[nextIndex.clamp(0, stages.length - 1)]);
  }
}
