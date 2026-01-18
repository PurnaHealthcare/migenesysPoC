export class QueryHandler {
    journeys = new Map();
    // In a real scenario, this would be triggered by an Event Bridge or DynamoDB Stream
    project(event) {
        switch (event.type) {
            case 'JourneyStarted':
                const startEvent = event;
                this.journeys.set(startEvent.aggregateId, {
                    id: startEvent.aggregateId,
                    title: startEvent.data.title,
                    startDate: startEvent.data.startDate,
                    status: 'Active'
                });
                break;
        }
    }
    getJourneys() {
        return Array.from(this.journeys.values());
    }
}
//# sourceMappingURL=query_handler.js.map